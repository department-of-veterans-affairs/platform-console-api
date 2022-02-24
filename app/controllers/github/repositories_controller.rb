# frozen_string_literal: true

module Github
  # Handles displaying repository info for an app
  class RepositoriesController < BaseController
    # GET /github/repositories/1 or /github/repositories/1.json
    def show; end

    def create_deploy_pr
      respond_to do |format|
        if @github_repository.dispatch_create_pr_workflow
          format.html do
            redirect_to team_app_github_repository_deploys_path(@team, @app, @app.github_repo),
                        notice: 'PR has been queued for creation.'
          end
          format.json { render json: true, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: false, status: :unprocessable_entity }
        end
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def github_repository_params
      params.permit(:team_id, :app_id, :repo)
    end
  end
end
