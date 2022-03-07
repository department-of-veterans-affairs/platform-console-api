# frozen_string_literal: true

require 'argo_cd/client'

# Handles creating deployments which are owned by an app
class DeploymentsController < ApplicationController
  before_action :authorize_session!
  before_action :set_app
  before_action :set_deployment, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @deployments = @app.deployments
    @pagy, @deployments = pagy @deployments
  end

  # GET /apps/1 or /apps/1.json
  def show
    argo_client = ArgoCd::Client.new(@app.id, @deployment.name, @current_user.id)
    @response = argo_client.app_info
    Rails.logger.debug "!!!!!!!#{@response.body}"
  end

  # GET /apps/new
  def new
    @deployment = @app.deployments.build
  end

  # GET /apps/1/edit
  def edit; end

  # POST /apps or /apps.json
  def create
    @deployment = @app.deployments.build(deployment_params)

    respond_to do |format|
      if @app.save
        format.html do
          redirect_to app_deployment_url(@app, @deployment), notice: 'Deployment was successfully created.'
        end
        format.json { render :show, status: :created, location: @deployment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1 or /apps/1.json
  def update
    respond_to do |format|
      if @deployment.update(deployment_params)
        format.html do
          redirect_to app_deployment_url(@app, @deployment), notice: 'Deployment was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @deployment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1 or /apps/1.json
  def destroy
    @deployment.destroy

    respond_to do |format|
      format.html { redirect_to app_deployments_url(@app), notice: 'Deployment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:app_id])
  end

  # Find the app deployment
  def set_deployment
    @deployment = @app.deployments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def deployment_params
    params.require(:deployment).permit(:name, :app_id)
  end
end
