# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying pull request info for an app
      class RepositoriesController < BaseController
        # GET /v1/teams/:team_id/apps/:app_id/repositories/:id
        def show
          @repository = ::Github::Repository.new(current_user.github_token, params[:id], @app.id)
          render json: ::Github::RepositorySerializer.new(@repository).serializable_hash
        end
      end
    end
  end
end
