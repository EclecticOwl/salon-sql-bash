#!/bin/bash

# salon appointment scheduler

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU() {
    if [[ $1 ]]
      then
        echo -e "\n$1"
    fi
    echo -e "\n<---{ Salon Services }--->\n"
    SERVE
    
}
SERVE() {
  SERVICE_MENU=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICE_MENU" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done

    read SERVICE_ID_SELECTED
    SERVE_REP=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVE_REP ]]
      then
        MAIN_MENU "This is not a valid service. Please use the ones provided."
    else
      echo -e "\nWhat is your phone number?"
      read CUSTOMER_PHONE
      PHONE_REP=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
      if [[ -z $PHONE_REP ]]
        then
          echo -e "\nWhat is your name?"
          read CUSTOMER_NAME
          CREATE_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
      fi
      echo -e "\nWhat appointment time?"
      read SERVICE_TIME
      CUSTOMER=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
      echo $CUSTOMER
      SERVICE_TYPE=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
      CREATE_APP=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
      echo -e "I have put you down for a $SERVICE_TYPE at $SERVICE_TIME, $CUSTOMER_NAME."
      
      
    fi
}

MAIN_MENU
