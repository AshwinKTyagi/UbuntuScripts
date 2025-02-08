"""
title: NBA Text to SQL Pipeline
author: Ashwin Tyagi
date: 2025-02-03
version: 1.1
license: MIT
description: This pipeline is used to query an NBA database using natural language questions and generate SQL queries to retrieve the answers.
"""
# requirements: open-webui, pydantic, sqlalchemy, llama_index, psycopg2-binary

import asyncio, aiohttp
import re
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


    def extract_sql(self, response):
        # Extract the SQL query from the response
        if self.debug:
            print(response)
        for key,value in response.items():
            if isinstance(value, dict) and "sql_query" in value:
                return value["sql_query"]
            elif key == "sql_query":
                return value
        return None
    
    # def extract_sql(self, response_text):
    #     # Extract the SQL query from the response
    #     match = re.search(r"SELECT .*", response_text, re.DOTALL | re.IGNORECASE)
    #     return match.group(0).strip() if match else response_text.strip()

    
    def handle_streaming_response(self, response):
        final_response = ""
        for chunk in response:
            final_response += chunk
        return final_response
        

    def pipe(self, user_message: str, model_id: str, messages: List[dict], body: dict)-> Union[str, Generator, Iterator]:
        # Emit a status update to show that pipe is connecting to the database
        print(f"pipe:{__name__}")
        
        if self.debug:
            print(f"pipe: {__name__} - received message from user: {user_message}")

            print(messages)
            print(user_message)

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
            #system header: provides instructions on how the AI should behave
            #user header: contains the natural language query
            #assistant: can provide an example SQL output if needed


        # text to sql prompt will be used to generate SQL queries from text
        text_to_sql_prompt = '''
        You are a helpful AI Assistant providing PostgreSQL commands to users.
        Make sure to always use the stop token you were trained on at the end of a response: <|eot_id|>         
        Given an input question, create a syntactically correct PostgreSQL query to run.
        You can order the results by a relevant column to return the most interesting examples in the database.
        Never query for all the columns from a specific table, only ask for a few relevant columns given the question.
        Only refer to the player table when asked if a player is actively playing. Otherwise, refer to the common_player_info table
        If a team is mentioned in the question, search the team table for the nickname in the nickname to get the team_id
        The common_player_info table connects to the team table on team_id and the player table on person_id
        The player table's is_active column has a value of 1 if the player is actively playing and 0 if they are not
        Only return the SQL query. Do not include any explanation, additional text, or formatting. 

        <|start_header_id|>user<|end_header_id|>
        Question: Who are the active players are on the Kings? <|eot_id|>

        SQLQuery: SELECT p.full_name FROM common_player_info AS cpi, player AS p, team AS t WHERE cpi.team_id = t.id AND cpi.person_id = p.id AND t.nickname = 'Kings' AND p.is_active = 1; <|eot_id|><|start_header_id|>assistant<|end_header_id|>

        <|start_header_id|>user<|end_header_id|>

        Here is the database schema:
        {schema}

        Question: {query_str} <|eot_id|> <|start_header_id|>assistant<|end_header_id|>
        SQLQuery:
        '''
        
        # generate human-readable responses from SQL queries
        synthesis_prompt = '''
        <|begin_of_text|><|start_header_id|>system<|end_header_id|>    
        You are an AI assistant that summarizes database query results in a user-friendly format.

        Given the SQL query result below, generate a human-readable response:
            
        Query Result:
        {query_result}

        Ensure the response is concise, formatted, and easy to understand.
        <|eot_id|>
        '''

        text_to_sql_template = PromptTemplate(text_to_sql_prompt)
        synthesis_prompt_template = PromptTemplate(synthesis_prompt)

        #set up the query engine
        query_engine = NLSQLTableQueryEngine(
            sql_database=sql_db,
            tables=self.valves.DB_TABLES,
            llm=llm,
            text_to_sql_prompt=text_to_sql_template,
            embed_model="local",
            synthesize_response=True,
            synthesis_prompt=synthesis_prompt_template,
            streaming=True,
        )

        try:
            response = query_engine.query(user_message)
            sql_query = self.extract_sql(response.metadata)

            # Check if the response is a streaming response and handle it accordingly
            if hasattr(response, "response_gen"):
                final_response = self.handle_streaming_response(response.response_gen)

                if self.debug:
                    print("\nSQL:\n", sql_query)
                    print("\nFinal\n", final_response)

                result = f"Generated SQL Query: \n ```sql\n{sql_query}\n``` \n {final_response}"
                return result
            else:
                final_response = response.response

                if self.debug:
                    print("\nSQL:\n", sql_query)
                    print("\nFinal\n", final_response)

                result = f"Generated SQL Query: \n```sql\n{sql_query}\n``` {final_response}"
                return result
            
        except aiohttp.ClientResponseError as e:
            logging.error(f"ClientResponseError: {e}")
            return f"ClientResponseError: {e}"
        except aiohttp.ClientPayloadError as e:
            logging.error(f"ClientPayloadError: {e}")
            return f"ClientPayloadError: {e}"        
        except aiohttp.ClientConnectionError as e:
            logging.error(f"ClinetConnectionError: {e}")
            return f"ClientConnectionError: {e}"
        except Exception as e:
            logging.error(f"Error: {e}")
            return f"Error: {e}"
