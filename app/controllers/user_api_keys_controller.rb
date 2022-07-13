# frozen_string_literal: true

# Handles management of users API keys
class UserApiKeysController < ApplicationController
  before_action :authorize_session!
  before_action :set_user_api_key, only: %i[destroy]

  def index
    @user_api_keys = current_user.api_keys
    @pagy, @user_api_keys = pagy @user_api_keys
  end

  def create
    token = ApiKey.generate_token
    respond_to do |format|
      if current_user.api_keys.create(token: token)
        format.html { redirect_to user_api_keys_path(current_user), notice: 'API key was successfully created' }
      else
        format.html { redirect_to user_api_keys_path(current_user), error: 'There was an error creating the API key' }
      end
    end
  end

  def destroy
    @user_api_key.destroy
    respond_to do |format|
      format.html { redirect_to user_api_keys_path(current_user), notice: 'API key was successfully destroyed.' }
    end
  end

  private

  def set_user_api_key
    @user_api_key = current_user.api_keys.find(params[:id])
  end
end
