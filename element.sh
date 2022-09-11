#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

SHOW_INFO() {
  if [[ $1 == 'number' ]]
  then
    INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius,type FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $2")
  else
    INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius,type FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.symbol = '$2' OR e.name = '$2'")
  fi

  if [[ -z $INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$INFO" | while read NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      OUTPUT="The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      echo $OUTPUT
    done
  fi
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  SHOW_INFO number $1
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  SHOW_INFO symbol $1
elif [[ $1 =~ ^[A-Z][a-z]{2,}$ ]]
then
  SHOW_INFO name $1
else
  SHOW_INFO
fi
