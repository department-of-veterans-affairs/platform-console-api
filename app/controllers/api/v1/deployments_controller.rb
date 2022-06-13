# frozen_string_literal: true

require 'argo_cd/client'

module Api
  module V1
    # Handles creating deployments which are owned by an app
    class DeploymentsController < ApplicationController
      before_action :set_app, :set_team
      before_action :set_deployment, only: %i[show update destroy]

      # GET /v1/teams/:team_id/deployments
      def index
        @deployments = @app.deployments
        render json: ::DeploymentSerializer.new(@deployments).serializable_hash
      end

      # GET /v1/teams/:team_id/deployments/:id
      def show
        render json: { error: 'ARGO_API is disabled.' }, status: :unprocessable_entity unless ENV['ARGO_API']
        if session[:keycloak_token].blank?
          render json: { error: 'Keycloak token is not present.' }, status: :unauthorized
        end

        argo_client = ArgoCd::Client.new(@app.id, @deployment.name, @current_user.id, session[:keycloak_token])
        @response = argo_client.app_info
        @current_revision = argo_client.current_revision(@response.current_git_revision) if @response.successful?
        render json: ::DeploymentSerializer.new(@current_revision).serializable_hash
      end

      # POST /v1/teams/:team_id/deployments
      def create
        @deployment = @app.deployments.build(deployment_params)

        if @app.save
          render json: ::DeploymentSerializer.new(@deployment).serializable_hash, status: :created
        else
          render json: @deployment.errors, status: :unprocessable_entity
        end
      end

      # PATCH /v1/teams/:team_id/deployments/:id
      def update
        if @deployment.update(deployment_params)
          render json: ::DeploymentSerializer.new(@deployment).serializable_hash, status: :ok
        else
          render json: @deployment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/teams/:team_id/deployments/:id
      def destroy
        @deployment.destroy

        head :no_content
      end

      private

      def set_team
        @team = Team.find(params[:team_id])
      end

      def set_app
        @app = App.find(params[:app_id])
      end

      def set_deployment
        @deployment = @app.deployments.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def deployment_params
        params.require(:deployment).permit(:name, :app_id)
      end
    end
  end
end
