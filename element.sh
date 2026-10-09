#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determine whether the argument is an atomic number
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="e.atomic_number = $1"
else
  CONDITION="e.symbol = '$1' OR e.name = '$1'"
fi

RESULT=$($PSQL "
SELECT format(
  'The element with atomic number %s is %s (%s). It''s a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.',
  e.atomic_number,
  e.name,
  e.symbol,
  t.type,
  p.atomic_mass,
  e.name,
  p.melting_point_celsius,
  p.boiling_point_celsius
)
FROM elements e
JOIN properties p USING (atomic_number)
JOIN types t USING (type_id)
WHERE $CONDITION;
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT"
fi
