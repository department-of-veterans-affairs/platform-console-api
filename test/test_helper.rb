# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start 'rails' do
    coverage_dir 'public/coverage'
  end
end

ENV['RAILS_ENV'] ||= 'test'
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
      Rails.application.env_config['omniauth.auth'] = keycloak_auth(user)
    end

    def keycloak_auth(user)
      OmniAuth.config.mock_auth[:keycloak] =
        OmniAuth::AuthHash.new(
          {
            provider: 'keycloak',
            info: {
              email: user.email,
              name: user.name,
              uid: user.uid,
              provider: user.provider
            }
          }
        )
    end

    def login_as(user)
      setup_omniauth_mock(users(user))
      visit '/login'
    end
  end
end
