# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :keycloak_openid, ENV['KEYCLOAK_CLIENT_ID'], ENV['KEYCLOAK_CLIENT_SECRET'],
            scope: 'openid profile email',
            client_options: { site: ENV['KEYCLOAK_SITE_URL'], realm: ENV['KEYCLOAK_REALM'] },
            name: 'keycloak'
end

OmniAuth.config.allowed_request_methods = %i[post get]
