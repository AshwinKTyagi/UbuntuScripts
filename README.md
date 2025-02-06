# Ubuntu Scripts

## create_nba_schema.sql

This SQL script will set up a postgres db using a [NBA Dataset](https://www.kaggle.com/datasets/wyattowalsh/basketball) from Kaggle.

1. **Drop Tables if They Exist**: The script starts by dropping several tables if they already exist in the database.The tables being dropped are:
   - `common_player_info`
   - `draft_combine_stats`
   - `draft_history`
   - `game`
   - `game_info`
   - `game_summary`
   - `inactive_players`
   - `line_score`
   - `officials`
   - `other_stats`
   - `play_by_play`
   - `player`
   - `team`
   - `team_details`
   - `team_history`

2. **Create Tables**: After dropping the tables, the script recreates each new table, specifying the columns and their data types. 

3. **Populate Tables**: Using psql's `\copy` command, the script populates the tables from their corresponding csv files. For tables that require data transformations, staging tables are created. Staging needed for `game_info`, `play_by_play`, `team` and `team_details`. 

## nba_text_to_sql_pipeline.py

This script sets up a pipeline to query an NBA database using natural language questions and generate SQL queries to retrieve the answers. It initializes a connection to a language model (LLM) and defines a custom prompt template for generating PostgreSQL queries based on user input. The script then uses a query engine to execute the generated SQL queries and return the results in a human-friendly format.