# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :keycloak_openid, ENV['KEYCLOAK_CLIENT_ID'] || 'account', ENV['KEYCLOAK_CLIENT_SECRET'] || '',
            scope: 'openid profile email',
            client_options: { site: 'http://localhost:8081',
                              realm: ENV['KEYCLOAK_REALM'] || 'Twilight' },
            name: 'keycloak'
end

OmniAuth.config.allowed_request_methods = %i[post get]
