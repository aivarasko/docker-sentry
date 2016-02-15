#!/bin/bash

FILE=".secret.sentry"
if [ ! -f $FILE ];
then
  tr -cd '[:alnum:]' < /dev/urandom | fold -w32 | head -n1 > $FILE
fi
SENTRY_SECRET_KEY=$(<$FILE)
echo "Setting SENTRY_SECRET_KEY="$SENTRY_SECRET_KEY

FILE=".secret.postgres"
if [ ! -f $FILE ];
then
  tr -cd '[:alnum:]' < /dev/urandom | fold -w32 | head -n1 > $FILE
fi
POSTGRES_PASSWORD=$(<$FILE)
echo "Settings POSTGRES_PASSWORD="$POSTGRES_PASSWORD

export SENTRY_SECRET_KEY=$SENTRY_SECRET_KEY
export POSTGRES_PASSWORD="$POSTGRES_PASSWORD"

docker-compose stop
docker-compose up -d postgres && sleep 4
docker-compose run postgres sh -c "PGPASSWORD=$POSTGRES_PASSWORD exec createdb -h \$POSTGRES_PORT_5432_TCP_ADDR -p \$POSTGRES_PORT_5432_TCP_PORT -U postgres sentry"
docker-compose run sentry sentry upgrade
SENTRY_SECRET_KEY=$SENTRY_SECRET_KEY,POSTGRES_PASSWORD=$POSTGRES_PASSWORD docker-compose up -d
docker-compose logs
