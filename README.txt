# Start Postgres instance
docker-compose up -d postgres

# Create sentry database
docker-compose run postgres sh -c 'exec createdb -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres sentry'

# Apply database schema migrations
docker-compose run sentry sentry upgrade

# Start all remaining instances
docker-compose up -d
