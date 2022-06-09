# frozen_string_literal: true

module Api
  module V1
    # Handles creating teams which will own apps
    class TeamsController < ApplicationController
      before_action :set_team, only: %i[show update destroy]

      # GET /v1/teams
      def index
        @teams = Team.all
        render json: ::TeamSerializer.new(@teams).serializable_hash
      end

      # GET /v1/teams/:id
      def show
        @team = Team.find_by(id: params[:id])
        render json: ::TeamSerializer.new(@team).serializable_hash
      end

      # POST /v1/teams
      def create
        @team = Team.new(team_params)
        @team.owner = current_user

        if @team.save
          render json: ::TeamSerializer.new(@team).serializable_hash, status: :created
        else
          render json: @team.errors, status: :unprocessable_entity
        end
      end

      # PATCH /v1/teams/:id
      def update
        if @team.update(team_params)
          render json: ::TeamSerializer.new(@team).serializable_hash, status: :ok
        else
          render json: @team.errors, status: :unprocessable_entity
        end
      end

      # DELETE /v1/teams/:id
      def destroy
        @team.destroy

        head :no_content
      end

      private

      def set_team
        @team = Team.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def team_params
        params.require(:team).permit(:name, :owner_id, :owner_type)
      end
    end
  end
end
