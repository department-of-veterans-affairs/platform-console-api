# frozen_string_literal: true

module Api
  module V1
    # Handles creating and modifying apps which are owned by a team
    class AppsController < ApplicationController
      before_action :set_team
      before_action :set_app, only: %i[show update destroy]

      # GET /v1/teams/:team_id/apps
      def index
        @apps = App.all
        render json: ::AppSerializer.new(@apps).serializable_hash
      end

      # GET /v1/teams/:team_id/apps/:id
      def show
        @app = App.find_by(id: params[:id])
        render json: ::AppSerializer.new(@app).serializable_hash
      end

      # POST /v1/teams/:team_id/apps
      def create
        @app = @team.apps.build(app_params)
        @app.current_user = current_user
        if @app.save
          render json: ::AppSerializer.new(@app).serializable_hash, status: :created
        else
          render json: @app.errors, status: :unprocessable_entity
        end
      end

      # PATCH /v1/teams/:team_id/apps/:id
      def update
        if @app.update(app_params)
          render json: ::AppSerializer.new(@app).serializable_hash, status: :ok
        else
          render json: @app.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/teams/:team_id/apps/:id
      def destroy
        @app.destroy

        head :no_content
      end

      private

      def set_team
        @team = Team.find(params[:team_id])
      end

      def set_app
        @app = @team.apps.find(params[:id])
        @app.current_user = current_user
      end

      # Only allow a list of trusted parameters through.
      def app_params
        params.require(:app).permit(:name, :team_id, :github_repo, :deploy_workflow)
      end
    end
  end
end
