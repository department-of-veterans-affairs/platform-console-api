# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_filter 'lib/templates'
    coverage_dir 'public/coverage'
  end
end

ENV['RAILS_ENV'] = 'test'
ENV['KEYCLOAK_SITE_URL'] = 'http://test.host/auth/keycloak/callback'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    WebMock.disable_net_connect!(allow_localhost: true)

    # Add more helper methods to be used by all tests here...

    def setup_omniauth_mock(user)
      stub_keycloak_requests
      OmniAuth.config.test_mode = true
      request = ActionDispatch::TestRequest.create
      request.env['omniauth.auth'] = keycloak_auth(user)
      get '/auth/keycloak/callback'
    end

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
      WebMock.stub_request(:get, 'http://test.host/auth/realms/Twilight/.well-known/openid-configuration')
             .to_return(status: 200, body: File.read(Rails.root.join('test/fixtures/files/keycloak_config.json')))

      WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/protocol/openid-connect/certs')
             .to_return(status: 200, body: { "keys": [] }.to_json)
    end
  end
end
