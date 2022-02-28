# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'flipper/adapters/redis'
require 'graphql/client'
require 'graphql/client/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PlatformConsole
  # Main application class for the Platform Console
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.generators do |g|
    #   g.test_framework :minitest
    # end
  end
end

module GitHub
  class Application < Rails::Application
  end

  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(_context)
      { 'Authorization' => "Bearer #{ENV['GITHUB_ACCESS_TOKEN']}" }
    end
  end

  # Fetch latest schema on init, this will make a network request
  # Schema = GraphQL::Client.load_schema(HTTP)

  # However, it's smart to dump this to a JSON file and load from disk
  #
  # Run it from a script or rake task
  # GraphQL::Client.dump_schema(GitHub::HTTP, 'db/schema.json')
  Schema = GraphQL::Client.load_schema('db/schema.json')

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
