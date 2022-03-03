# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :keycloak_openid, ENV['KEYCLOAK_CLIENT_ID'] || 'account', ENV['KEYCLOAK_CLIENT_SECRET'] || '',
            scope: 'openid profile email', redirect_uri: ENV['KEYCLOAK_REDIRECT_URI'],
            client_options: { site: ENV['KEYCLOAK_SITE_URL'],
                              realm: ENV['KEYCLOAK_REALM'] },

            name: 'keycloak',
            strategy_class: OmniAuth::Strategies::KeycloakOpenId
end

OmniAuth.config.allowed_request_methods = %i[post get]
