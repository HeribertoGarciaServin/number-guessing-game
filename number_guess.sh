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

echo "Guess the secret number between 1 and 1000:"

while true
do
  read -r GUESS || exit 0

  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

  if [[ ! $GUESS =~ ^-?[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else
    break
  fi
done
