# frozen_string_literal: true

# Handles logging a user in and out
class SessionsController < ApplicationController
  layout 'pages'

  def new
    return create if params[:uid]
    return redirect_to root_path if current_user

    @user = User.new
  end

  def create
    @user = User.find_by email: params[:email]

    if password_correct? || user_via_uid
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

  def password_correct?
    @user&.authenticate params[:password]
  end

  def user_via_uid
    @user = User.find_by uid: params[:uid]
  end

  def store_user_in_cookie
    cookies.permanent[:user] = [@user.id, @user.password_digest[0, 29], Time.now.utc.to_i]
  end

  def after_login_path
    session[:after_login_path] || root_path
  end
end
