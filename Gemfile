# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.1.2'

gem 'rails', '~> 7.0.3'

gem 'bcrypt',             '~> 3.1' # Use ActiveModel has_secure_password
gem 'bootsnap',           '~> 1.12', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'ddtrace',            '~> 0.54', require: 'ddtrace/auto_instrument' # Datadog's tracing client for Ruby
gem 'faraday-http-cache', '~> 2.4' # middleware that respects HTTP cache by checking expiration of the stored responses.
gem 'flipper',            '~> 0.25' # Feature flipper for ANYTHING
gem 'flipper-redis',      '~> 0.25' # Redis adapter for Flipper
gem 'flipper-ui',         '~> 0.25' # UI for the Flipper gem
gem 'graphql-client',     '~> 0.18' # Ruby library for declaring, composing and executing GraphQL queries.
gem 'jbuilder',           '~> 2.11' # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jsonapi-serializer', '~> 2.2'  # A fast JSON:API serializer for Ruby Objects.
gem 'jwt',                '~> 2.4'  # Ruby implementation of the JWT standard
gem 'net-http',           '~> 0.2' # HTTP client api for Ruby
gem 'octokit',            '~> 5.1'   # Ruby toolkit for the GitHub API.
gem 'omniauth-keycloak',  '~> 1.4'   # Keycloack SSO Oauth Strategy
gem 'omniauth-rails_csrf_protection', '~> 1.0.1' # Mitigates against CSRF in oauth flow
gem 'pagy',               '~> 5.10'  # Agnostic pagination in plain ruby
gem 'paper_trail',        '~> 12.3'  # Track changes to your models, for auditing or versioning
gem 'pg',                 '~> 1.4'   # Use postgresql as the database for Active Record
gem 'puma',               '>= 5.6.4' # Use the Puma web server [https://github.com/puma/puma]
gem 'redis',              '~> 4.7'   # Use Redis adapter to run Action Cable in production
gem 'rolify',             '~> 6.0'   # Simple Roles library
gem 'rouge',              '~> 3.29'  # Pure Ruby syntax highlighter
gem 'rswag-api',          '~> 2.5.1' # Swagger library to help generate open API documentation
gem 'rswag-ui',           '~> 2.5.1' # UI for rswag documentation
gem 'rubyzip',            '~> 2.3'   # Ruby library for reading and writing zip files.
gem 'sidekiq',            '~> 6.5'   # Simple, efficient background processing for Ruby
gem 'strong_migrations',  '~> 1.2'   # Catch potentially dangerous operations in migrations

# Assets
gem 'importmap-rails',    '~> 1.1' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'redcarpet',          '~> 3.5' # For Markdown processing [https://github.com/vmg/redcarpet]
gem 'sprockets-rails',    '~> 3.4' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails',     '~> 1.0' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'tailwindcss-rails',  '~> 2.0' # Integrate Tailwind CSS with the asset pipeline
gem 'turbo-rails',        '~> 1.1' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

group :development do
  gem 'rack-mini-profiler' # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
end

group :development, :test do
  gem 'brakeman'          # Detects security vulnerabilities in via static analysis
  gem 'bundler-audit'     # Provides patch-level verification for Bundled apps
  gem 'pry-awesome_print' # Auto AP in pry
  gem 'pry-rails'         # Adds pry, an interactive REPL debugger; Try show-models
  gem 'rspec-rails'       # Testing framework, required for rswag-specs
  gem 'rswag-specs'       # Rspec DSL that can generate open api docs directly from specs
  gem 'rubocop'           # Ruby Style Guide Analyzer
  gem 'rubocop-rails'     # Add Rails specific cops to RuboCop
end

group :test do
  gem 'capybara'           # Adds support for Capybara system testing and selenium driver
  gem 'minitest-ci'        # Minitest Junit XML results for GHA
  gem 'selenium-webdriver' # Capybara system testing with Chrome
  gem 'simplecov'          # Code coverage for Ruby
  gem 'vcr'                # Record/replay HTTP interactions
  gem 'webdrivers'         # Easy installation and use of web drivers to run system tests with browsers
  gem 'webmock'            # Stubbing and setting expectations in HTTP requests
end
