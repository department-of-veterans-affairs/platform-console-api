# README

The Platform Console API: for creating and deploying applications on the VA Platform.

The intention of this project is to work out integrations with underlying VA services (e.g. K8s, SSM, AWS) which will provide API services for the Platform Console UI and Platform Console CLI. UI work contained within this project is only to aid in defining API features.

## Getting Started

From the root of the repository, run:

```bash
brew install postgres
brew services start postgresql
bin/setup
bin/dev
```

This will:
1. Install and run Postgres.
2. Install the necessary gems, create the pg database, and seed the database.
3. Start the Rails server and Tailwind watcher.

This has been tested on macOS Monterey using Ruby 3.1 and PG 14.1.

## Running tests

To run all tests, run:

```bash
rails test:all
```

If you'd like a coverage report generated, preface the command with `COVERAGE=true`.

To run a single test, run:

```bash
rails test test/path/to/the_test.rb:123
```

## Deployment

While we await provisioning of appropriate services on the VA network, we are hosting the platform-console on Heroku. Each commit to master is automatically deployed and each pull request will generate a Review App.
