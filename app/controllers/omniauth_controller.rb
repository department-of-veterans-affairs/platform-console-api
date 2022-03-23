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

  def slack_api
    if session[:slack_token].blank?
      response = Faraday.post("https://slack.com/api/oauth.access") do |req|
        req.headers =
          {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        req.body = "code=#{params[:code]}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
      end
      #session[:slack_token] = JSON.parse(response.body)["authed_user"]["access_token"]
    end
    redirect_to slack_index_path
  end

  private

  def set_user
    @user = User.from_omniauth(auth_hash)
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
