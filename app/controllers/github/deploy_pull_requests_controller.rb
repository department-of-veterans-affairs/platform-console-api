# frozen_string_literal: true

module Github
  # Handles creation of pull requests to add a Workflow file.
  class DeployPullRequestsController < BaseController
    def create
      respond_to do |format|
        if @app.repository(current_user.github_token).create_deploy_workflow_pr
          format.html do
            redirect_to team_app_deploys_path(@team, @app),
                        notice: 'Pull Request has been created.'
          end
          format.json { render json: true, status: :ok }
        else
          format.html do
            redirect_to team_app_deploys_path(@team, @app), status: :unprocessable_entity,
                                                            alert: 'Pull Request was unable to be created.'
          end
          format.json { render json: false, status: :unprocessable_entity }
        end
      end
    end
  end
end
