# frozen_string_literal: true

# Adds helper methods for api key authentication
module ApiKeyAuthenticable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_api_key, :current_bearer

  def authenticate_with_api_key!
    @current_bearer = authenticate_or_request_with_http_token(&method(:authenticator))
    @current_user = @current_bearer if @current_bearer.is_a?(User)
  end

  private

  attr_writer :current_api_key, :current_bearer

  def authenticator(http_token, _options)
    @current_api_key = ApiKey.find_by token: http_token
    current_api_key&.bearer
  end
end
