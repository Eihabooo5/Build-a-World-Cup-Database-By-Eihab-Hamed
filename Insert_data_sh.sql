#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_TEAM=$($PSQL "select name from teams where name='$WINNER'")
  OPPONENT_TEAM=$($PSQL "select name from teams where name='$OPPONENT'")
  
  # INSERT new records (unique winner teams) into teams table
  if [[ $WINNER != winner ]]
  then
    if [[ -z $WINNER_TEAM ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_TEAM == 'INSERT 0 1' ]]
      then 
        echo "Inserted $WINNER in teams table"
      fi
    fi
  fi
      # Insert opponent teams in teams table

        if [[ $OPPONENT != opponent ]]
        then
          if [[ -z $OPPONENT_TEAM ]]
          then
            INSERT_OPPONENT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
              if [[ $INSERT_OPPONENT_TEAM = 'INSERT 0 1' ]]
              then
                echo "Inserted $OPPONENT in the teams table"
          
          
              fi
            fi
          fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  GAMES_ID=$($PSQL "select game_id from games inner join teams on games.winner_id = teams.team_id and games.opponent_id = teams.team_id")
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  # Insert new records in the games table
  if [[ $YEAR != year ]]
  then
    if [[ -z $GAMES_ID ]]
    then 
      INSERT_RECORD_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_RECORD_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserted $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS in games table"
      fi
    fi
  fi
done
