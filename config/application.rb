# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'flipper/adapters/redis'

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
    # config.time_zone = 'Central Time (US & Canada)'
    # config.eager_load_paths << Rails.root.join('extras")
    config.session_store :cookie_store, key: '_platform_console_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.active_record.encryption.key_derivation_salt = ENV['KEY_DERIVATION_SALT']
    config.active_record.encryption.primary_key = ENV['ENCRYPTION_PRIMARY_KEY']
    config.active_record.encryption.deterministic_key = ENV['DETERMINISTIC_KEY']
    config.active_record.encryption.support_unencrypted_data = true
  end
end
