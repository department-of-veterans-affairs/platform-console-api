# frozen_string_literal: true

module OmniAuthMockHelper
  OmniAuth.config.test_mode = true

  def setup_omniauth_mock(user)
    keycloak_setup(user)
    get '/auth/keycloak/callback'
  end

  def keycloak_setup(user)
    stub_keycloak_requests
    Rails.application.env_config['omniauth.auth'] = keycloak_auth(user)
  end

  def stub_keycloak_requests
    WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/.well-known/openid-configuration')
           .to_return(status: 200, body: File.read(Rails.root.join('test/fixtures/files/keycloak_config.json')))

    WebMock.stub_request(:get, 'http://test.host/auth/realms/example-realm/protocol/openid-connect/certs')
           .to_return(status: 200, body: { "keys": [] }.to_json)
  end

  def keycloak_auth(user)
    OmniAuth.config.mock_auth[:keycloak] =
      OmniAuth::AuthHash.new(
        {
          uid: user.uid,
          provider: 'keycloak',
          credentials: {
            token:
            'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJERUs0UWNmR2pNMUZBeEpBSU9iRDdrQWwtVm1jYUU0b0loWm9KYjFreVcwIn0'
          },
          info: {
            email: user.email,
            name: user.name
          }
        }
      )
  end
end
