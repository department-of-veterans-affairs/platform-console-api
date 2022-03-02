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

    config.before_initialize do
      require 'dotenv'
      # Setup GraphQL
      unless File.exist?(Rails.root.join('tmp/github_graphql_schema.json'))
        # Download GraphQL schema
        adapter = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
          def headers(_context)
            { 'Authorization' => "Bearer #{ENV['GITHUB_ACCESS_TOKEN']}" }
          end
        end
        GraphQL::Client.dump_schema(adapter, 'tmp/github_graphql_schema.json')
      end
    end
  end
end
