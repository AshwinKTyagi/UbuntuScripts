
drop table if exists common_player_info;
drop table if exists draft_combine_stats;
drop table if exists draft_history;
drop table if exists game;
drop table if exists game_info;
drop table if exists game_summary;
drop table if exists inactive_players;
drop table if exists line_score;
drop table if exists officials;
drop table if exists other_stats;
drop table if exists play_by_play;
drop table if exists player;
drop table if exists team;
drop table if exists team_details;
drop table if exists team_history;


CREATE TABLE common_player_info (
    person_id                          integer,
    first_name                         text,
    last_name                          text,
    display_first_last                 text,
    display_last_comma_first           text,
    display_fi_last                    text,
    player_slug                        text,
    birthdate                          timestamp without time zone,
    school                             text,
    country                            text,
    last_affiliation                   text,
    height                             text,  -- stored as text because of the format "6-10"
    weight                             integer,
    season_exp                         double precision,  -- using double to accept "5.0"
    jersey                             text,
    position                           text,
    rosterstatus                       text,
    games_played_current_season_flag   text,
    team_id                            bigint,
    team_name                          text,
    team_abbreviation                  text,
    team_code                          text,
    team_city                          text,
    playercode                         text,
    from_year                          double precision,  -- to accept "1990.0"
    to_year                            double precision,  -- to accept "1994.0"
    dleague_flag                       text,
    nba_flag                           text,
    games_played_flag                  text,
    draft_year                         text,
    draft_round                        text,
    draft_number                       text,
    greatest_75_flag                   text
);

CREATE TABLE draft_combine_stats (
    season                          integer,
    player_id                       integer,
    first_name                      text,
    last_name                       text,
    player_name                     text,
    position                        text,
    height_wo_shoes                 double precision,  -- sample value: 76.5
    height_wo_shoes_ft_in           text,              -- sample: 6' 4.5''
    height_w_shoes                  double precision,  -- sample: 77.5
    height_w_shoes_ft_in            text,              -- sample: 6' 5.5''
    weight                          double precision,  -- sample: 203.6
    wingspan                        double precision,  -- sample: 80.0
    wingspan_ft_in                  text,              -- sample: 6' 8''
    standing_reach                  double precision,  -- sample: 100.5
    standing_reach_ft_in            text,              -- sample: 8' 4.5''
    body_fat_pct                    double precision,  -- sample: 6.45
    hand_length                     double precision,  -- sample: 8.5
    hand_width                      double precision,  -- sample: 9.0
    standing_vertical_leap          double precision,  -- sample: 29.0
    max_vertical_leap               double precision,  -- sample: 34.5
    lane_agility_time               double precision,  -- sample: 10.6
    modified_lane_agility_time        double precision,  -- sample: 3.2
    three_quarter_sprint            double precision,  -- sample: 3.12
    bench_press                     double precision,  -- sample: 7.0
    spot_fifteen_corner_left        text,              -- sample: (empty)
    spot_fifteen_break_left         text,              -- sample: (empty)
    spot_fifteen_top_key            text,              -- sample: (empty)
    spot_fifteen_break_right        text,              -- sample: (empty)
    spot_fifteen_corner_right       text,              -- sample: (empty)
    spot_college_corner_left        text,              -- sample: 2-5
    spot_college_break_left         text,              -- sample: 3-5
    spot_college_top_key            text,              -- sample: 2-5
    spot_college_break_right        text,              -- sample: 3-5
    spot_college_corner_right       text,              -- sample: 3-5
    spot_nba_corner_left            text,              -- sample: 1-5
    spot_nba_break_left             text,              -- sample: 3-5
    spot_nba_top_key                text,              -- sample: 4-5
    spot_nba_break_right            text,              -- sample: 2-5
    spot_nba_corner_right           text,              -- sample: 3-5
    off_drib_fifteen_break_left     text,              -- sample: (empty)
    off_drib_fifteen_top_key        text,              -- sample: (empty)
    off_drib_fifteen_break_right    text,              -- sample: (empty)
    off_drib_college_break_left     text,              -- sample: (empty)
    off_drib_college_top_key        text,              -- sample: (empty)
    off_drib_college_break_right    text,              -- sample: (empty)
    on_move_fifteen                 text,              -- sample: (empty)
    on_move_college                 text               -- sample: (empty)
);

CREATE TABLE draft_history (
    person_id            integer,
    player_name          text,
    season               integer,
    round_number         integer,
    round_pick           integer,
    overall_pick         integer,
    draft_type           text,
    team_id              bigint,
    team_city            text,
    team_name            text,
    team_abbreviation    text,
    organization         text,
    organization_type    text,
    player_profile_flag  integer
);

CREATE TABLE game (
    season_id                integer,
    team_id_home             bigint,
    team_abbreviation_home   text,
    team_name_home           text,
    game_id                  text,  -- using text to preserve any leading zeros
    game_date                timestamp without time zone,
    matchup_home             text,
    wl_home                  text,
    min                      integer,
    fgm_home                 double precision,
    fga_home                 double precision,
    fg_pct_home              double precision,
    fg3m_home                double precision,
    fg3a_home                double precision,
    fg3_pct_home             double precision,
    ftm_home                 double precision,
    fta_home                 double precision,
    ft_pct_home              double precision,
    oreb_home                double precision,
    dreb_home                double precision,
    reb_home                 double precision,
    ast_home                 double precision,
    stl_home                 double precision,
    blk_home                 double precision,
    tov_home                 double precision,
    pf_home                  double precision,
    pts_home                 double precision,
    plus_minus_home          integer,
    video_available_home     integer,
    team_id_away             bigint,
    team_abbreviation_away   text,
    team_name_away           text,
    matchup_away             text,
    wl_away                  text,
    fgm_away                 double precision,
    fga_away                 double precision,
    fg_pct_away              double precision,
    fg3m_away                double precision,
    fg3a_away                double precision,
    fg3_pct_away             double precision,
    ftm_away                 double precision,
    fta_away                 double precision,
    ft_pct_away              double precision,
    oreb_away                double precision,
    dreb_away                double precision,
    reb_away                 double precision,
    ast_away                 double precision,
    stl_away                 double precision,
    blk_away                 double precision,
    tov_away                 double precision,
    pf_away                  double precision,
    pts_away                 double precision,
    plus_minus_away          integer,
    video_available_away     integer,
    season_type              text
);

CREATE TABLE game_info (
    game_id    text,
    game_date  timestamp without time zone,
    attendance integer,
    game_time  interval
);

CREATE TABLE game_summary (
    game_date_est                    timestamp without time zone,
    game_sequence                    double precision,
    game_id                          text,
    game_status_id                   integer,
    game_status_text                 text,
    gamecode                         text,
    home_team_id                     bigint,
    visitor_team_id                  bigint,
    season                           integer,
    live_period                      integer,
    live_pc_time                     text,  -- blank sample; change type if needed
    natl_tv_broadcaster_abbreviation text,
    live_period_time_bcast           text,
    wh_status                        integer
);

CREATE TABLE inactive_players (
    game_id            text,    -- Use text to preserve any leading zeros
    player_id          integer,
    first_name         text,
    last_name          text,
    jersey_num         integer,
    team_id            bigint,
    team_city          text,
    team_name          text,
    team_abbreviation  text
);

CREATE TABLE line_score (
    game_date_est           timestamp without time zone,
    game_sequence           double precision,
    game_id                 text,  -- text preserves leading zeros (e.g. "0021800311")
    team_id_home            bigint,
    team_abbreviation_home  text,
    team_city_name_home     text,
    team_nickname_home      text,
    team_wins_losses_home   text,
    pts_qtr1_home           double precision,
    pts_qtr2_home           double precision,
    pts_qtr3_home           double precision,
    pts_qtr4_home           double precision,
    pts_ot1_home            double precision,
    pts_ot2_home            double precision,
    pts_ot3_home            double precision,
    pts_ot4_home            double precision,
    pts_ot5_home            double precision,
    pts_ot6_home            double precision,
    pts_ot7_home            double precision,
    pts_ot8_home            double precision,
    pts_ot9_home            double precision,
    pts_ot10_home           double precision,
    pts_home                double precision,
    team_id_away            bigint,
    team_abbreviation_away  text,
    team_city_name_away     text,
    team_nickname_away      text,
    team_wins_losses_away   text,
    pts_qtr1_away           double precision,
    pts_qtr2_away           double precision,
    pts_qtr3_away           double precision,
    pts_qtr4_away           double precision,
    pts_ot1_away            double precision,
    pts_ot2_away            double precision,
    pts_ot3_away            double precision,
    pts_ot4_away            double precision,
    pts_ot5_away            double precision,
    pts_ot6_away            double precision,
    pts_ot7_away            double precision,
    pts_ot8_away            double precision,
    pts_ot9_away            double precision,
    pts_ot10_away           double precision,
    pts_away                double precision
);

CREATE TABLE officials (
    game_id      text,    -- Stored as text to preserve any leading zeros
    official_id  integer,
    first_name   text,
    last_name    text,
    jersey_num   integer
);

CREATE TABLE other_stats (
    game_id                text,                -- Using text to preserve any leading zeros
    league_id              text,                -- "00" is stored as text
    team_id_home           bigint,
    team_abbreviation_home text,
    team_city_home         text,
    pts_paint_home         integer,
    pts_2nd_chance_home    integer,
    pts_fb_home            integer,
    largest_lead_home      integer,
    lead_changes           integer,
    times_tied             integer,
    team_turnovers_home    double precision,    -- sample: "0.0"
    total_turnovers_home   double precision,    -- sample: "12.0"
    team_rebounds_home     double precision,    -- sample: "11.0"
    pts_off_to_home        double precision,             -- sample is blank; column can accept NULL
    team_id_away           bigint,
    team_abbreviation_away text,
    team_city_away         text,
    pts_paint_away         integer,
    pts_2nd_chance_away    integer,
    pts_fb_away            integer,
    largest_lead_away      integer,
    team_turnovers_away    double precision,    -- sample: "0.0"
    total_turnovers_away   double precision,    -- sample: "23.0"
    team_rebounds_away     double precision,    -- sample: "11.0"
    pts_off_to_away        double precision              -- sample is blank; column can accept NULL
);

CREATE TABLE play_by_play (
    game_id                     text,               -- e.g., "0029600993"
    eventnum                    integer,            -- e.g., 38
    eventmsgtype                integer,            -- e.g., 1
    eventmsgactiontype          integer,            -- e.g., 5
    period                      integer,            -- e.g., 1
    wctimestring                text,               -- e.g., "11:46 PM"
    pctimestring                text,               -- e.g., "5:55"
    homedescription             text,               -- (may be empty)
    neutraldescription          text,               -- (may be empty)
    visitordescription          text,               -- e.g., "Trent Layup (6 PTS) (Sabonis 2 AST)"
    score                       text,               -- e.g., "13 - 13"
    scoremargin                 text,               -- e.g., "TIE"
    person1type                 double precision,   -- e.g., 5.0
    player1_id                  integer,            -- e.g., 718
    player1_name                text,               -- e.g., "Gary Trent"
    player1_team_id             bigint,             -- e.g., 1610612757 (the CSV shows "1610612757.0")
    player1_team_city           text,               -- e.g., "Portland"
    player1_team_nickname       text,               -- e.g., "Trail Blazers"
    player1_team_abbreviation   text,               -- e.g., "POR"
    person2type                 double precision,   -- e.g., 5.0
    player2_id                  integer,            -- e.g., 717
    player2_name                text,               -- e.g., "Arvydas Sabonis"
    player2_team_id             bigint,             -- e.g., 1610612757 (from "1610612757.0")
    player2_team_city           text,               -- e.g., "Portland"
    player2_team_nickname       text,               -- e.g., "Trail Blazers"
    player2_team_abbreviation   text,               -- e.g., "POR"
    person3type                 double precision,   -- e.g., 4.0
    player3_id                  integer,            -- e.g., 0
    player3_name                text,               -- (empty in sample)
    player3_team_id             bigint,             -- e.g., 1610612737 (from "1610612737.0")
    player3_team_city           text,               -- e.g., "Atlanta"
    player3_team_nickname       text,               -- e.g., "Hawks"
    player3_team_abbreviation   text,               -- e.g., "ATL"
    video_available_flag        integer             -- e.g., 0
);

CREATE TABLE player (
    id         integer,
    full_name  text,
    first_name text,
    last_name  text,
    is_active  integer
);

CREATE TABLE team (
    id            bigint,
    full_name     text,
    abbreviation  text,
    nickname      text,
    city          text,
    state         text,
    year_founded  integer
);

CREATE TABLE team_details (
    team_id            bigint,   -- Example: 1610612737
    abbreviation       text,     -- Example: ATL
    nickname           text,     -- Example: Hawks
    yearfounded        integer,  -- Example: 1949 (from 1949.0)
    city               text,     -- Example: Atlanta
    arena              text,     -- Example: State Farm Arena
    arenacapacity      integer,  -- Example: 18729 (from 18729.0)
    owner              text,     -- Example: Tony Ressler
    generalmanager     text,     -- Example: Travis Schlenk
    headcoach          text,     -- Example: Quin Snyder
    dleagueaffiliation text,     -- Example: College Park Skyhawks
    facebook           text,     -- Example: https://www.facebook.com/hawks
    instagram          text,     -- Example: https://instagram.com/atlhawks
    twitter            text      -- Example: https://twitter.com/ATLHawks
);

CREATE TABLE team_history (
    team_id         bigint,   -- Example: 1610612737
    city            text,     -- Example: Atlanta
    nickname        text,     -- Example: Hawks
    year_founded    integer,  -- Example: 1968
    year_active_till integer  -- Example: 2019
);

-- insert values

\copy common_player_info FROM '/home/ashwint/Downloads/nba_db/csv/common_player_info.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy draft_combine_stats FROM '/home/ashwint/Downloads/nba_db/csv/draft_combine_stats.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy draft_history FROM '/home/ashwint/Downloads/nba_db/csv/draft_history.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy game FROM '/home/ashwint/Downloads/nba_db/csv/game.csv' WITH (FORMAT csv, HEADER true, NULL '');
-- do staging for game_info
\copy game_summary FROM '/home/ashwint/Downloads/nba_db/csv/game_summary.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy inactive_players FROM '/home/ashwint/Downloads/nba_db/csv/inactive_players.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy line_score FROM '/home/ashwint/Downloads/nba_db/csv/line_score.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy officials FROM '/home/ashwint/Downloads/nba_db/csv/officials.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy other_stats FROM '/home/ashwint/Downloads/nba_db/csv/other_stats.csv' WITH (FORMAT csv, HEADER true, NULL '');
-- do staging for play_by_play
\copy player FROM '/home/ashwint/Downloads/nba_db/csv/player.csv' WITH (FORMAT csv, HEADER true, NULL '');
-- do staging for team
-- do staging for team_details
\copy team_history FROM '/home/ashwint/Downloads/nba_db/csv/team_history.csv' WITH (FORMAT csv, HEADER true, NULL '');



-- game_info staging for outlier values

CREATE TABLE game_info_staging (
    game_id    text,
    game_date  text,
    attendance text,
    game_time  text
);

\copy game_info_staging FROM '/home/ashwint/Downloads/nba_db/csv/game_info.csv' WITH (FORMAT csv, HEADER true, NULL '');

INSERT INTO game_info (game_id, game_date, attendance, game_time)
SELECT
    game_id,
    game_date::timestamp,
    -- Convert attendance from text (e.g. "17548.0") to numeric then round and cast to integer.
    round(attendance::numeric)::integer,
    -- For game_time, if the seconds part equals 60, convert "1:60" to "2:00", otherwise just cast.
    CASE
        WHEN split_part(game_time, ':', 2)::integer = 60 THEN
            (split_part(game_time, ':', 1)::integer + 1 || ':00')::interval
        ELSE
            game_time::interval
    END
FROM game_info_staging;
DROP TABLE game_info_staging;

-- play_by_play staging

CREATE TABLE play_by_play_staging (
    game_id                     text,
    eventnum                    text,
    eventmsgtype                text,
    eventmsgactiontype          text,
    period                      text,
    wctimestring                text,
    pctimestring                text,
    homedescription             text,
    neutraldescription          text,
    visitordescription          text,
    score                       text,
    scoremargin                 text,
    person1type                 text,
    player1_id                  text,
    player1_name                text,
    player1_team_id             text,
    player1_team_city           text,
    player1_team_nickname       text,
    player1_team_abbreviation   text,
    person2type                 text,
    player2_id                  text,
    player2_name                text,
    player2_team_id             text,
    player2_team_city           text,
    player2_team_nickname       text,
    player2_team_abbreviation   text,
    person3type                 text,
    player3_id                  text,
    player3_name                text,
    player3_team_id             text,
    player3_team_city           text,
    player3_team_nickname       text,
    player3_team_abbreviation   text,
    video_available_flag        text
);

\copy play_by_play_staging FROM '/home/ashwint/Downloads/nba_db/csv/play_by_play.csv' WITH (FORMAT csv, HEADER true, NULL '');

INSERT INTO play_by_play (
    game_id,
    eventnum,
    eventmsgtype,
    eventmsgactiontype,
    period,
    wctimestring,
    pctimestring,
    homedescription,
    neutraldescription,
    visitordescription,
    score,
    scoremargin,
    person1type,
    player1_id,
    player1_name,
    player1_team_id,
    player1_team_city,
    player1_team_nickname,
    player1_team_abbreviation,
    person2type,
    player2_id,
    player2_name,
    player2_team_id,
    player2_team_city,
    player2_team_nickname,
    player2_team_abbreviation,
    person3type,
    player3_id,
    player3_name,
    player3_team_id,
    player3_team_city,
    player3_team_nickname,
    player3_team_abbreviation,
    video_available_flag
)
SELECT
    game_id,
    eventnum::integer,
    eventmsgtype::integer,
    eventmsgactiontype::integer,
    period::integer,
    wctimestring,
    pctimestring,
    homedescription,
    neutraldescription,
    visitordescription,
    score,
    scoremargin,
    person1type::double precision,
    player1_id::integer,
    player1_name,
    round(player1_team_id::numeric)::bigint,
    player1_team_city,
    player1_team_nickname,
    player1_team_abbreviation,
    person2type::double precision,
    player2_id::integer,
    player2_name,
    round(player2_team_id::numeric)::bigint,
    player2_team_city,
    player2_team_nickname,
    player2_team_abbreviation,
    person3type::double precision,
    player3_id::integer,
    player3_name,
    round(player3_team_id::numeric)::bigint,
    player3_team_city,
    player3_team_nickname,
    player3_team_abbreviation,
    video_available_flag::integer
FROM play_by_play_staging;
DROP TABLE play_by_play_staging;

-- team_staging for year conversion to integer

CREATE TABLE team_staging (
    id            text,
    full_name     text,
    abbreviation  text,
    nickname      text,
    city          text,
    state         text,
    year_founded  text
);

\copy team_staging FROM '/home/ashwint/Downloads/nba_db/csv/team.csv' WITH (FORMAT csv, HEADER true, NULL '');

INSERT INTO team (id, full_name, abbreviation, nickname, city, state, year_founded)
SELECT
    id::bigint,
    full_name,
    abbreviation,
    nickname,
    city,
    state,
    round(year_founded::numeric)::integer
FROM team_staging;
drop table	team_staging;

-- team details staging for outlier values

CREATE TABLE team_details_staging (
    team_id            text,
    abbreviation       text,
    nickname           text,
    yearfounded        text,
    city               text,
    arena              text,
    arenacapacity      text,
    owner              text,
    generalmanager     text,
    headcoach          text,
    dleagueaffiliation text,
    facebook           text,
    instagram          text,
    twitter            text
);

\copy team_details_staging FROM '/home/ashwint/Downloads/nba_db/csv/team_details.csv' WITH (FORMAT csv, HEADER true, NULL '');

INSERT INTO team_details (
    team_id,
    abbreviation,
    nickname,
    yearfounded,
    city,
    arena,
    arenacapacity,
    owner,
    generalmanager,
    headcoach,
    dleagueaffiliation,
    facebook,
    instagram,
    twitter
)
SELECT
    team_id::bigint,
    abbreviation,
    nickname,
    -- Convert "1949.0" to numeric then round (if needed) and cast to integer
    round(yearfounded::numeric)::integer,
    city,
    arena,
    -- Convert "18729.0" similarly; adjust this column if it represents attendance instead of capacity
    round(arenacapacity::numeric)::integer,
    owner,
    generalmanager,
    headcoach,
    dleagueaffiliation,
    facebook,
    instagram,
    twitter
FROM team_details_staging;
drop table	team_details_staging;
