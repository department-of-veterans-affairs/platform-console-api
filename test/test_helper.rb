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
ENV['GITHUB_CLIENT_ID'] ||= 'github_client_id'
ENV['GITHUB_CLIENT_SECRET'] ||= 'github_client_secret'
ENV['KEYCLOAK_SITE_URL'] = 'http://test.host/auth/keycloak/callback'
ENV['KEYCLOAK_REALM'] = 'example-realm'
ENV['ARGO_API_BASE_PATH'] = 'http://argocd.local.com'
require_relative '../config/environment'
require 'rails/test_help'
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

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers

    # Don't parallelize because there is an issue with simplecov
    # See: https://github.com/simplecov-ruby/simplecov/issues/718
    # parallelize(workers: :number_of_processors)

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

    def keycloak_setup(user)
      stub_keycloak_requests
      Rails.application.env_config['omniauth.auth'] = keycloak_auth(user)
    end

    def setup_omniauth_mock(user)
      keycloak_setup(user)
      get '/auth/keycloak/callback'
    end

    def keycloak_auth(user)
      OmniAuth.config.mock_auth[:keycloak] =
        OmniAuth::AuthHash.new(
          {
            uid: user.uid,
            provider: 'keycloak',
            credentials: {
              token:
              '"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJERUs0UWNmR2pNMUZBeEpBSU9iRDdrQWwtVm1jYUU0b0loWm9KYjFreVcwIn0.eyJleHAiOjE2NTEwMTI5NTcsImlhdCI6MTY1MDk3ODE0MywiYXV0aF90aW1lIjoxNjUwOTc2OTU3LCJqdGkiOiIxMTdjMWUyNy1jZTdlLTQ0ZGEtOTdjMC1mMzA3MjA1ODcxY2MiLCJpc3MiOiJodHRwOi8vZjg1Yy0xMzEtMTUwLTEzOS0xMTkubmdyb2suaW8vYXV0aC9yZWFsbXMvVHdpbGlnaHQiLCJhdWQiOlsiZGV4IiwiYXJnb2NkIiwiYWNjb3VudCJdLCJzdWIiOiJjMTAyMzU4Ny0yODVhLTRhYmUtYmY1Yi1kMzRlYzhmMDQ5NmIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhY2NvdW50Iiwic2Vzc2lvbl9zdGF0ZSI6IjZiMzU5Zjg4LTBlNmUtNDYxMC1hMTM4LTI0MTQ2YTU1MzVjNSIsImFjciI6IjAiLCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctYXBwbGljYXRpb25zIiwidmlldy1jb25zZW50IiwiYWRtaW4iLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsIm1hbmFnZS1jb25zZW50IiwiZGVsZXRlLWFjY291bnQiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBncm91cHMgcHJvZmlsZSBnb29kLXNlcnZpY2UgZW1haWwiLCJzaWQiOiI2YjM1OWY4OC0wZTZlLTQ2MTAtYTEzOC0yNDE0NmE1NTM1YzUiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJLZXljbG9hayBVc2VyIiwiZ3JvdXBzIjpbIkFyZ29DREFkbWlucyIsIlNlbnRyeSIsImRhdGFkb2ciXSwicHJlZmVycmVkX3VzZXJuYW1lIjoia2V5Y2xvYWtfdXNlciIsImdpdmVuX25hbWUiOiJLZXljbG9hayIsImZhbWlseV9uYW1lIjoiVXNlciIsImVtYWlsIjoia2V5Y2xvYWtfdXNlckBleGFtcGxlLmNvbSJ9.UEAf6ftg3OPdle3I-BAPyWhdjh0S6P7WP8CRAPOcJBqoFBMQOfaIJGDtdJPNbLRPCr3sE6tWJS2w6W7KF8IzNCiwd7umJu0jef8_n8Waz8S4nzMfcE70snrgTptToDedWaLXEE_GWK5BBkJus4R--XAVO8MPd0TNWV4JrTXnN_VZCNp5G9pOgzv_PXoVZNSFMQgCH9OvPyNlThV7AHzbdp7f0TlTiwG3ZEca3-CuWucvaqScqiTxDfOdgd3DuUhS3l8Cigp5am5izMRvGB7bd670ovFuPm88ZFjGD0mGp7hn-j6CUFRiOxUb6EdmeTyDQJ4c5zucZHQ3L4jeHu14Zw'
            },
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

    def omniauth_login_as(user)
      keycloak_setup(user)
      visit '/auth/keycloak/callback'
    end

    def stub_keycloak_requests
      WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/.well-known/openid-configuration')
             .to_return(status: 200, body: File.read(Rails.root.join('test/fixtures/files/keycloak_config.json')))

      WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/protocol/openid-connect/certs')
             .to_return(status: 200, body: { "keys": [] }.to_json)
    end
  end
end
