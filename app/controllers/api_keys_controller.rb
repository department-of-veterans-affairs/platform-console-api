# frozen_string_literal: true

# Handles management of  API keys
class ApiKeysController < ApplicationController
  before_action :authorize_session!
  before_action :set_api_key, only: %i[destroy]

  def index
    @api_keys = ApiKey.all
    @pagy, @api_keys = pagy @api_keys
  end

  def destroy
    @api_key.destroy
    respond_to do |format|
      format.html { redirect_to api_keys_path }
    end
  end

  private

  def set_api_key
    @api_key = ApiKey.find(params[:id])
  end
end
