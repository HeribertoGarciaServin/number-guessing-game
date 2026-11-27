#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -q -c"

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

echo "Enter your username:"
read -r USERNAME

USERNAME_SQL=${USERNAME//\'/\'\'}

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_SQL'")

if [[ -z $USER_ID ]]
then
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME_SQL')" > /dev/null

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_SQL'")

  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")

  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")

  if [[ $GAMES_PLAYED == 0 ]]
  then
    BEST_GAME=0
  fi

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
