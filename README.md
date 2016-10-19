LOUISIANA CALLING
=======================================

This code repository is a starter code base for creating a server with ruby, RAILS, nginx, unicorn, and postgreSQL installed. There are a few things that need to be setup in order for this to work for other individuals.

## Features
 - Rails
 - Postgresql

## Local folder structure
```
[root]
    [app]       # All source code
    [config]      # Contains rails config
    [db]        # Contains database
    [lib]       # Contains rails library
    [log]       # Contains rails logs
    [public]      # Contains public
    [test]        # Contains test cases
    [tmp]       # Temporary directory
    [vendor]
      [asserts]   # Vendor
```

## Requirements
**Ruby**
 - Ruby installed with Ruby gems (2.3.0 or later)
 - (Home page)(https://www.ruby-lang.org/en/downloads/)

**PostgreSQL**
 - PostgreSQL is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness.
 - [Homepage](https://www.postgresql.org/)

### Usage
**Make sure you installed tools from section requirements**

##### 1. Init project
- Clone and checkout source code

    ```
    git clone git@github.com:CspenceGroup/LouisianaCalling-api.git <project_name>
    cd <project_name>
    git chekout develop
    ```

- Install requirements libs
    ```
    bundle install
    ```
### Development:

1. Database initiazlization

    ```
    bundle exec rake db:create
    bundle exec rake db:migrate
    ```
2. Start Server

  ```
  bundle exec rails s
  ```
