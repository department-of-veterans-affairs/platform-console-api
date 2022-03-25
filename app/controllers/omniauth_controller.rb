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
    @user = User.from_omniauth(auth_hash)
  end

  protected

  def auth_hash
    puts "!!!!!!!!!!#{request.env['omniauth.auth']}"
    request.env['omniauth.auth']
  end
end
