# frozen_string_literal: true

# Handles omniauth SSO logins
class OmniauthController < SessionsController
  layout 'pages'
  before_action :set_user, only: :keycloak_openid

  def keycloak_openid
    if @user.present? && @user.persisted?
      store_user_in_cookie
      redirect_to after_login_path, notice: 'Logged in successfully.'
    else
      redirect_to login_path, alert: t('.alert')
    end
  end

  private

  def set_user
    @user = User.from_omniauth(auth_hash, keycloak_token_hash)
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def keycloak_token_hash
    return nil if auth_hash['credentials'].blank?

    conn = Faraday.new
    response = conn.post(ENV['KEYCLOAK_TOKEN_URL']) do |req|
      req.headers =
        {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Authorization' => "Bearer #{auth_hash['credentials']['token']}"
        }
      req.body = 'grant_type=urn:ietf:params:oauth:grant-type:uma-ticket&audience=account'
    end
    JWT.decode(JSON.parse(response.body)['access_token'], nil, false)
  end
end
