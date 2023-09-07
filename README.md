# UNIFIED

This is a Rails 7 app.

Release version 0.7.0

## Documentation

This README describes the purpose of this repository and how to set up a development environment. Other sources of documentation are as follows:

- UI and API designs are in `doc/`
- Server setup instructions are in `PROVISIONING.md`
- Staging and production deployment instructions are in `DEPLOYMENT.md`

## Prerequisites

This project requires:

- Ruby 3.2.2, preferably managed using [rbenv] or [asdf][]
- Chromedriver for Capybara testing
- PostgreSQL must be installed and accepting connections
- [Redis][] must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew][].

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).


## Getting Started

To get started with the app, clone the repo and then install the needed gems:

```
$ gem install bundler -v 2.3.22
$ bundle _2.3.22_ config set --local without 'production'
$ bundle _2.3.22_ install
```

Create the database :

```
$ rails db:create
```

Next, migrate the database:

```
$ rails db:migrate

$ rails db:seed # optional
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server or bin/dev
```