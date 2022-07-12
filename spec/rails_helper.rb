# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV['GITHUB_CLIENT_ID'] ||= 'github_client_id'
ENV['GITHUB_CLIENT_SECRET'] ||= 'github_client_secret'
ENV['GITHUB_ACCESS_TOKEN'] ||= 'github_token'
ENV['KEYCLOAK_SITE_URL'] = 'http://test.host/auth/keycloak/callback'
ENV['KEYCLOAK_REALM'] = 'example-realm'
ENV['ARGO_API_BASE_PATH'] = 'http://argocd.local.com'
ENV['BASE_URL'] ||= 'test.host'

require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'support/shared_contexts/request_test'
require 'support/omni_auth_mock_helper'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('github_token') { ENV['GITHUB_ACCESS_TOKEN'] }
  config.filter_sensitive_data('github_client_id') { ENV['GITHUB_CLIENT_ID'] }
  config.filter_sensitive_data('github_client_secret') { ENV['GITHUB_CLIENT_SECRET'] }
  # whitelist 127.0.0.1 so VCR doesn't interfere with system tests
  config.ignore_hosts '127.0.0.1', 'chromedriver.storage.googleapis.com'
  config.ignore_request do |request|
    request.uri.include?('example.com')
  end
end

# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include OmniAuthMockHelper
end
