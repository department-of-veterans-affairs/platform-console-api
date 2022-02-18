# frozen_string_literal: true

# Handles logging a user in and out
class SessionsController < ApplicationController
  layout 'pages'

  def new
    return create if params.dig('request.omniauth', :uid)
    return redirect_to root_path if current_user

    @user = User.new
  end

  def create
    set_user
    if @user.present? && @user.persisted?
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

  def set_user
    if params[:email]
      @user = User.find_by email: params[:email]
      @user = password_correct? ? @user : nil
    else
      @user = User.find_by uid: params.dig('request.omniauth', :uid)
    end
  end

  def password_correct?
    @user&.authenticate params[:password]
  end

  def store_user_in_cookie
    cookies.permanent[:user] = [@user.id, @user.uid, Time.now.utc.to_i]
  end

  def after_login_path
    session[:after_login_path] || root_path
  end
end
