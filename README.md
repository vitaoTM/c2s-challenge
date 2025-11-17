# Desafio Técnico C2S 

This is a developer test created by C2S. A responsive email info extracter 

Main features:

- Upload .eml files
- Extract customer info from email files:
 - name, phone, product_code, email.
- Process in background job

## Version Used in this Project

<div align="center">

|System|  Version Command  | Version |
|:------|:-------------------:|:---------:|
|[ruby](https://www.ruby-lang.org/en/documentation/installation/)| `ruby -v`|`3.4.5`  |
|[rails](https://guides.rubyonrails.org/)|`rails -v`|`8.0.4`|
|[redis](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/)/valkey|`redis-cli -v`| `valkey-cli 8.1.4` |
|[postgreSQL](https://www.postgresql.org/download/)| `psql -V`| `17` |

</div>

## Clone or download this repo

```
git clone git@github.com:vitaoTM/
cd c2s-challenge
```

### Get started with Docker

1. Build and run the app

```
docker-compose Build
docker-compose up -d # to run in detached mode
```

2. Set up Database

```
docker-compose exec web bin/rails db:setup
```

3. Access the app

The application should be running on:
`http://localhost:3000`

Check sidekiq on:
`http://localhost:3000/sidekiq`


4. Stop the application

To stop all running Docker containers
`docker-compose down`


### Get started locally 

To run locally please check your versions of:

- Ruby version file: `.ruby-version`
- Rails: see `Gemfile`
- PostgreSQL: Must be installed and runnig.


1. Setup Database and install gems
```
bundle install
bin/rails db:create db:migrate
```

2. Run the app

```
bin/dev
```

- Access localhost: `http://localhost:3000`
- Access sidekiq: `http://localhost:3000:sidekiq`

3. To exit application:
`^C` (ctrl + c)

4. Run tests locally:

`rspec spec/`

