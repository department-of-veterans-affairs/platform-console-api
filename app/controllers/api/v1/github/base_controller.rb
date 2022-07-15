# frozen_string_literal: true

module Api
  module V1
    module Github
      # Base controller of shared methods for classes in Github Module
      class BaseController < ApplicationController
        before_action :authenticate_with_api_key!
        before_action :set_team
        before_action :set_app
        before_action :set_github_repository
        rescue_from Octokit::Unauthorized, with: :unauthorized
        rescue_from Octokit::Forbidden, with: :unauthorized

        private

        def unauthorized(exception)
          render json: exception.message, status: :unauthorized
        end

        def set_github_repository
          return redirect_to edit_team_app_path(@team, @app) if @app.github_repo.blank?

          @github_repository = ::Github::Repository.new(current_user.github_token, @app.github_repo, @app.id)
        end

        def set_app
          @app = App.find(params[:app_id])
        end

        def set_team
          @team = Team.find(params[:team_id])
        end
      end
    end
  end
end
