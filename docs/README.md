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

## Semantic Releases

This repository uses semantic releases triggered via Github Actions. When committing to the master branch, a semantic release will be triggered via Github Actions, but the commit message must follow the syntax in the [semantic release documentation](https://github.com/semantic-release/semantic-release#how-does-it-work).

### Examples

```text
1. feat: add my feature
2. fix: fix the bug
3. BREAKING CHANGE: fix the breaking change
4. perf: remove some change
```

## Migrations

### Schema migrations

All schema migrations are run automatically upon a successful semantic release and deploy. The initContainers configuration in the platform-console-api k8s deployment spec will start and execute migrations before the other containers in the pod start.

### Data Migrations

All data migrations will need to be run via a manual process.

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

With respect to semantic release syntax, each commit to master is automatically built and the image is pushed to ECR. The image tag is then updated in the manifests repo in the deployment.yml

## Keycloak Integration

Instructions for running and initializing Keycloak locally:
  To setup keycloak, run:

  ```bash
  bin/keycloak
  ```

  This will create a keycloak database, docker image, and a docker container (Keycloak).
  You can access keycloak at <http://localhost:8080>

### Keycloak Credentails
  
  ```text
  ADMIN Credentials (Create Realms):
  username: admin
  password: password
  ```

  ```text
  Keycloak SSO credentials:
  username: keycloak_user@example.com
  password: password
  ```

## Running ArgoCd Locally

See the [Argo Integration docs](https://vfs.atlassian.net/wiki/spaces/VI/pages/2121465877/Running+ArgoCd+Locally+for+platform-console-api) in Confluence

## Open API Documentation

The Rswag gem is used to automatically generate documentation for the platform console API endpoints. Documentation can be viewed in an embedded version of swagger-ui by running `rails server` and then visiting the `/api-docs/index.html` path.

### Updating Swagger Documentation

If the API has changed and the documentation needs to be updated, rswag can generate an updated Swagger file using the following command:

```bash
SWAGGER_DRY_RUN=0 RAILS_ENV=test rails rswag
```

This will create an updated Swagger JSON file using the request specs in the `spec/requests/api/v1` folder.
