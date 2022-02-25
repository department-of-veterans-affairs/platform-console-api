# frozen_string_literal: true

module Github
  # Handles displaying deploy run info for an app
  class DeployRunsController < BaseController
    before_action :set_github_deploy_run, only: %i[show rerun]

    # GET /github/deploy_runs/1 or /github/deploy_runs/1.json
    def show
      @jobs = @github_deploy_run.jobs
    end

    def rerun # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @github_deploy_run.rerun!
          path = team_app_deploy_path(@team, @app, @app.github_repo, params[:deploy_id])
          format.html { redirect_to path, notice: 'deploy run was sucessfully restarted' }
          format.json { render json: true }
        else
          path = team_app_deploy_deploy_run_path(@team, @app, @app.github_repo,
                                                 params[:deploy_id], params[:id])
          format.html { redirect_to path, notice: 'There was a problem restarting the deploy run' }
          format.json { render json: false }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy_run
      @github_deploy_run = Github::DeployRun.new(@app.github_repo, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_deploy_run_params
      params.fetch(:github_deploy_run, {})
    end
  end
end
