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
ENV['KEYCLOAK_SITE_URL'] = 'http://www.example.com/auth/keycloak/callback'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def setup_omniauth_mock(user)
      OmniAuth.config.test_mode = true
      request = ActionDispatch::Request.new({})
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
  end
end
