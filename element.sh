#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

FIND_ELEMENT() {
    if [[ -n $1 ]]
    then
        # Check if argument is atomic number, symbol, or name
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1' OR atomic_number::text='$1';")
        # If no element found in database
        if [[ -z $ATOMIC_NUMBER ]]
        then
            # Return element not found message
            echo I could not find that element in the database.
        else
            # Look up element details using atomic number
            NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
            TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
            MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
            MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
            BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")

            echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi  
    else
        # If no arguments provided, request element argument
        echo Please provide an element as an argument.
    fi
}

FIND_ELEMENT "$1"