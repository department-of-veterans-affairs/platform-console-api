# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.1.0'

gem 'rails', '~> 7.0.2'

gem 'bcrypt',            '~> 3.1' # Use ActiveModel has_secure_password
gem 'bootsnap',          '~> 1.10', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'flipper',           '~> 0.24' # Feature flipper for ANYTHING
gem 'flipper-redis',     '~> 0.24' # Redis adapter for Flipper
gem 'flipper-ui',        '~> 0.24' # UI for the Flipper gem
gem 'jbuilder',          '~> 2.11' # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'omniauth-keycloak', '~> 1.4'  # Keycloack SSO Oauth Strategy
gem 'omniauth-rails_csrf_protection'
gem 'pagy',              '~> 5.10' # Agnostic pagination in plain ruby
gem 'paper_trail',       '~> 12.2' # Track changes to your models, for auditing or versioning
gem 'pg',                '~> 1.3'  # Use postgresql as the database for Active Record
gem 'puma',              '~> 5.6'  # Use the Puma web server [https://github.com/puma/puma]
gem 'redis',             '~> 4.6'  # Use Redis adapter to run Action Cable in production
gem 'rolify',            '~> 6.0'  # Simple Roles library
gem 'sidekiq',           '~> 6.4'  # Simple, efficient background processing for Ruby
gem 'strong_migrations', '~> 0.8'  # Catch potentially dangerous operations in migrations

# Assets
gem 'importmap-rails',   '~> 1.0' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'sprockets-rails',   '~> 3.4' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails',    '~> 1.0' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'tailwindcss-rails', '~> 2.0' # Integrate Tailwind CSS with the asset pipeline
gem 'turbo-rails',       '~> 1.0' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

group :development do
  gem 'rack-mini-profiler' # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
end

group :development, :test do
  gem 'brakeman'          # Detects security vulnerabilities in via static analysis
  gem 'bundler-audit'     # Provides patch-level verification for Bundled apps
  gem 'pry-awesome_print' # Auto AP in pry
  gem 'pry-rails'         # Adds pry, an interactive REPL debugger; Try show-models
  gem 'rubocop'           # Ruby Style Guide Analyzer
  gem 'rubocop-rails'     # Add Rails specific cops to RuboCop
end

group :test do
  gem 'capybara'           # Adds support for Capybara system testing and selenium driver
  gem 'minitest-ci'        # Minitest Junit XML results for GHA
  gem 'selenium-webdriver' # Capybara system testing with Chrome
  gem 'simplecov'          # Code coverage for Ruby
  gem 'webdrivers'         # Easy installation and use of web drivers to run system tests with browsers
end
