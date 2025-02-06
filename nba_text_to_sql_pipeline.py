"""
title: NBA Text to SQL Pipeline
author: Ashwin Tyagi
date: 2025-02-03
version: 1.1
license: MIT
description: This pipeline is used to query an NBA database using natural language questions and generate SQL queries to retrieve the answers.
requirements: open-webui, pydantic, sqlalchemy, llama_index, psycopg2-binary
"""

import asyncio, aiohttp
from pydantic import BaseModel
from typing import List, Union, Generator, Iterator
import os
from llama_index.llms.ollama import Ollama
from llama_index.core.query_engine import NLSQLTableQueryEngine
from llama_index.core import SQLDatabase, PromptTemplate
from sqlalchemy import create_engine

import logging

logging.basicConfig(level=logging.DEBUG)

class Pipeline:
    class Valves(BaseModel):
        DB_ENGINE: str
        DB_HOST: str
        DB_PORT: str
        DB_USER: str
        DB_PASSWORD: str
        DB_DATABASE: str
        DB_TABLES: List[str]
        OLLAMA_HOST: str
        TEXT_TO_SQL_MODEL: str
        CONTEXT_WINDOW: int = 4096

    def __init__(self):
        self.name = "SQL Query on NBA Database"
        self.engine = None
        self.nlsql_response = ""
        self.debug = False

        self.valves = self.Valves(
            **{
                "pipelines": ["*"],
                "DB_ENGINE": os.getenv("DB_ENGINE", "postgres"),
                "DB_HOST": os.getenv("PG_HOST", "http://host.docker.internal"),
                "DB_PORT": os.getenv("PG_PORT", "5432"),
                "DB_USER": os.getenv("PG_USER", "ashwint"),
                "DB_PASSWORD": os.getenv("PG_PASSWORD", "Akty_2001"),
                "DB_DATABASE": os.getenv("PG_DB", "nba_db"),
                "DB_TABLES": ["*"],
                "OLLAMA_HOST": os.getenv("OLLAMA_HOST", "http://host.docker.internal:11435"),
                "TEXT_TO_SQL_MODEL": "mistral",
                "CONTEXT_WINDOW": 4096
            }
        )

    def init_db_connection(self):
        # Initialize the database connection
        self.engine = create_engine(
            f"postgresql+psycopg2://{self.valves.DB_USER}:{self.valves.DB_PASSWORD}@{self.valves.DB_HOST}:{self.valves.DB_PORT}/{self.valves.DB_DATABASE}"
        )
        return self.engine
    
    async def on_startup(self):
        print(f"on_startup:{__name__}")
        # Create a database engine
        self.init_db_connection()
        

    async def on_shutdown(self):
        print(f"on_shutdown:{__name__}")
        pass
    
    async def make_request_with_retry(self, url, params, retries=3, timeout=10):
        for attempt in range(retries):
            try:
                async with aiohttp.ClientSession() as session:
                    async with session.get(url, params=params, timeout=timeout) as response:
                        return await response.text()
            except (aiohttp.ClientResponseError, aiohttp.ClientPayloadError, aiohttp.ClientConnectionError) as e:
                logging.error(f"Request failed: {e}")
                if attempt >= retries - 1:
                    raise
                await asyncio.sleep(2 ** attempt)


    def extract_sql_query(self, response):
        # Extract the SQL query from the response
        for key,value in response.items():
            if isinstance(value, dict) and "sql_query" in value:
                return value["sql_query"]
            elif key == "sql_query":
                return value
        return None
    
    def handle_streaming_response(self, response):
        final_response = ""
        for chunk in response:
            final_response += chunk
        return final_response
        

    def pipe(self, user_message: str, model_id: str, messages: List[dict], body: dict)-> Union[str, Generator, Iterator]:
        # Emit a status update to show that pipe is connecting to the database
        print(f"pipe:{__name__}")
        
        print(messages)
        print(user_message)

        if self.debug:
            print(f"pipe: {__name__} - received message from user: {user_message}")

        # Create a database engine
        sql_db = SQLDatabase(self.engine, include_tables=self.valves.DB_TABLES)

        #set up llm connection
        llm = Ollama(
            model=self.valves.TEXT_TO_SQL_MODEL,
            base_url=self.valves.OLLAMA_HOST,
            request_timeout=300.0,
            context_window=self.valves.CONTEXT_WINDOW,
        )

        #set up custom prompt template for generating SQL queries from text
        text_to_sql_prompt = '''
        <|begin_of_text|><|start_header_id|>system<|end_header_id|>    
        You are a helpful AI Assistant providing PostgreSQL commands to users.
        Make sure to always use the stop token you were trained on at the end of a response: <|eot_id|>
        
        Given an input question, create a syntactically correct PostgreSQL query to run.
        You can order the results by a relevant column to return the most interesting examples in the database.
        Unless the user specifies in the question a specific number of examples to obtain, query for at most 5 results using the LIMIT clause as per Postgres.
        Never query for all the columns from a specific table, only ask for a few relevant columns given the question.
        You should use DISTINCT statements and avoid returning duplicates wherever possible.
        Pay attention to use only the column names that you can see in the schema description. Be careful to not query for columns that do not exist. Pay attention to which column is in which table. Also, qualify column names with the table name when needed. 
        
        
        Please include all of the following in your response:
        - The original question
        - The SQL query to run
        - The raw result from the SQL execution
        - A final, human-friendly answer to the question    

        Here is the schema of the database:
        {schema}

        question: {query_str}
        SQLQuery:
        '''
        
        text_to_sql_template = PromptTemplate(text_to_sql_prompt)

        #set up the query engine
        query_engine = NLSQLTableQueryEngine(
            sql_database=sql_db,
            tables=self.valves.DB_TABLES,
            llm=llm,
            text_to_sql_prompt=text_to_sql_template,
            embed_model="local",
            synthesize_response=False,
            streaming=True,
        )

        try: 
            response = query_engine.query(user_message)
            sql_query = self.extract
        return response.response_gen