#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    TEAM_ID_FOR_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    if [[ -z $TEAM_ID_FOR_WINNER ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    fi
    TEAM_ID_FOR_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")


    TEAM_ID_FOR_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    if [[ -z $TEAM_ID_FOR_OPPONENT ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    fi
    TEAM_ID_FOR_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $TEAM_ID_FOR_WINNER, $TEAM_ID_FOR_OPPONENT, $winner_goals, $opponent_goals)")
  fi
done