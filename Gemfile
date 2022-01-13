source 'https://rubygems.org'

ruby '~> 3.1.0'

gem 'rails', '~> 7.0.1'

gem 'bootsnap', '~> 1.9', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'pg',       '~> 1.1'  # Use postgresql as the database for Active Record
gem 'puma',     '~> 5.0'  # Use the Puma web server [https://github.com/puma/puma]
gem 'jbuilder', '~> 2.11' # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'redis',    '~> 4.0'  # Use Redis adapter to run Action Cable in production

# Assets
gem 'importmap-rails', '~> 1.0' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'sprockets-rails', '~> 3.4' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails',  '~> 1.0' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'turbo-rails',     '~> 1.0' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

group :development do
  gem 'rack-mini-profiler' # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
end

group :development, :test do
  gem 'pry-awesome_print' # Auto AP in pry
  gem 'pry-rails'         # Adds pry, an interactive REPL debugger; Try show-models
end

group :test do
  gem 'capybara'           # Adds support for Capybara system testing and selenium driver
  gem 'selenium-webdriver' # Capybara system testing with Chrome
  gem 'webdrivers'         # Easy installation and use of web drivers to run system tests with browsers
end
