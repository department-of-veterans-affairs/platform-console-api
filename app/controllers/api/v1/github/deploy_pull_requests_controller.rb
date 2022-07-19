# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles creation of pull requests to add a Workflow file
      class DeployPullRequestsController < BaseController
        # POST /v1/teams/:team_id/apps/:app_id/deploy_pull_requests
        def create
          if @app.repository(current_user.github_token).create_deploy_workflow_pr
            render json: true, status: :ok
          else
            render json: false, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
