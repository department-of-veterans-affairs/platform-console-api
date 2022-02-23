# frozen_string_literal: true

# Adds helper methods for authentication
module Authenticatable
  extend ActiveSupport::Concern

  included do
    def current_user
      @current_user ||= User.where(id: current_session.id).find_by(
        'password_digest LIKE ?', "#{current_session.password}%"
      )
    end

    helper_method :current_user if respond_to? :helper_method

    def authorize_session!
      store_after_login_path
      return if current_user

      cookies.permanent[:user] = nil
      redirect_to login_path, alert: t('auth.log_in.alert')
    end

    private

    def current_session
      id, password, created_at = cookies.permanent[:user]
      created_at = Time.at(created_at).utc if created_at
      OpenStruct.new id: id, password: password, created_at: created_at
    end

    def store_after_login_path
      session[:after_login_path] = controller_name
    end
  end
end
