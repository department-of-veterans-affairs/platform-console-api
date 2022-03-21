# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_filter 'lib/templates'
    add_filter 'lib/dotenv'
    coverage_dir 'public/coverage'
  end
end

ENV['RAILS_ENV'] ||= 'test'
ENV['KEYCLOAK_SITE_URL'] = 'http://test.host/auth/keycloak/callback'
ENV['KEYCLOAK_REALM'] = 'example-realm'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data('github_token') { ENV['GITHUB_ACCESS_TOKEN'] }
  config.filter_sensitive_data('github_client_id') { ENV['GITHUB_CLIENT_ID'] }
  config.filter_sensitive_data('github_client_secret') { ENV['GITHUB_CLIENT_SECRET'] }
  # whitelist 127.0.0.1 so VCR doesn't interfere with system tests
  config.ignore_hosts '127.0.0.1'
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    WebMock.disable_net_connect!(
      {
        allow_localhost: true,
        allow: 'chromedriver.storage.googleapis.com' # Needed for GitHub runners
      }
    )

    # Add more helper methods to be used by all tests here...
    OmniAuth.config.test_mode = true

    def setup_omniauth_mock(user)
      stub_keycloak_requests
      Rails.application.env_config["omniauth.auth"] = keycloak_auth(user)
      get '/auth/keycloak/callback'
    end

    # keycloak_auth(user)
    #   Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:keycloak]
    #   get "/auth/keycloak"

    def keycloak_auth(user)
      OmniAuth.config.mock_auth[:keycloak] =
        OmniAuth::AuthHash.new(
          {
            uid: user.uid,
            provider: 'keycloak',
            info: {
              email: user.email,
              name: user.name
            }
          }
        )
    end

    def login_as(user)
      visit "/login?request.omniauth[uid]=#{users(user).uid}"
    end

    def stub_keycloak_requests
      WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/.well-known/openid-configuration')
             .to_return(status: 200, body: File.read(Rails.root.join('test/fixtures/files/keycloak_config.json')))

      WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/protocol/openid-connect/certs')
             .to_return(status: 200, body: { "keys": [] }.to_json)
    end
  end
end
