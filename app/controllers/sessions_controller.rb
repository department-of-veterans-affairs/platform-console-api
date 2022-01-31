# frozen_string_literal: true

# Handles logging a user in and out
class SessionsController < ApplicationController
  layout 'pages'
  before_action :set_omniauth_user, only: :create

  def new
    return create if params[:token]
    return redirect_to root_path if current_user

    @user = User.new
  end

  def create
    if @user.present?
      store_user_in_cookie
      redirect_to after_login_path, notice: t('.notice')
    else
      redirect_to login_path, alert: t('.alert')
    end
  end

  def destroy
    cookies.permanent[:user] = nil
    redirect_to root_path, notice: t('.notice')
  end

  private

  def store_user_in_cookie
    cookies.permanent[:user] = [@user.id, @user.uid, Time.now.utc.to_i]
  end

  def after_login_path
    session[:after_login_path] || root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def set_omniauth_user
    @user = auth_hash.present? && auth_hash['provider'].present? ? User.find_or_create_by_omniauth(auth_hash) : nil
  end
end
