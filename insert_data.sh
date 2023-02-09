#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
HELLO="echo hello"
$HELLO
# clear db
echo  $($PSQL "TRUNCATE games, teams RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# check if winning team exists
if [[ $WINNER != winner ]]
  then
  TEAM=$($PSQL "SELECT name FROM teams WHERE name ILIKE '$WINNER'")
  if [[ $TEAM == "" ]]
    # if it does not exist store it in teams db
    then 
    echo $WINNER
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER');"
  fi
fi

# check if losing team exists
if [[ $OPPONENT != opponent ]]
then
  TEAM=$($PSQL "SELECT name FROM teams WHERE name ILIKE '$OPPONENT'")
  # if it does not exist store it in teams db
  if [[ $TEAM == "" ]]
    then 
    echo $OPPONENT
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"
  fi
fi
done

# GAMES DB

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then
#get winner id
W_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$WINNER'")
echo $W_ID
#get opponent id
O_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$OPPONENT'")
echo $O_ID

#insert all data
$PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES ('$YEAR', '$ROUND', '$W_ID', '$O_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')"
fi
done
