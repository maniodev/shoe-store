## Inventory monitor

It consists of three  services:

- **server**: publishes the events.
- **events_consumer**: consumes the events and saves them into Redis streams and sets.
- **inventory_monitor**: displays the current inventory, progress chart and recommendations.

### Installation

1 - Build the containers

```
docker-compose build
```

2 - Setup the database

```
docker-compose run web bundle exec rails db:create
docker-compose run web bundle exec rails db:migrate
```

3 - Run the application

```
docker-compose up
```

Head over to http://localhost:3000 


### API:


The GrapQL API can be explored at http://localhost:3000/graphiql


### Tests:

```
docker-compose run -e "RAILS_ENV=test" web bundle exec rspec
docker-compose run events_consumer bundle exec rspec
```
