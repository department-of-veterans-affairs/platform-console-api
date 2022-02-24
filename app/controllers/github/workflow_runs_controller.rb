# frozen_string_literal: true

module Github
  # Handles displaying workflow run info for an app
  class WorkflowRunsController < BaseController
    before_action :set_github_workflow_run, only: %i[show rerun]

    # GET /github/workflow_runs or /github/workflow_runs.json
    def index
      @github_workflow_runs = Github::WorkflowRun.all(@github_repository.repo)
    end

    # GET /github/workflow_runs/1 or /github/workflow_runs/1.json
    def show
      @jobs = @github_workflow_run.jobs
    end

    def rerun # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @github_workflow_run.rerun!
          path = team_app_github_repository_workflow_path(@team, @app, @app.github_repo,
                                                          github_workflow_run_params[:workflow_id])
          format.html { redirect_to path, notice: 'Workflow run was sucessfully restarted' }
          format.json { render json: true }
        else
          path = team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo,
                                                                       github_workflow_run_params[:workflow_id],
                                                                       github_workflow_run_params[:id])
          format.html { redirect_to path, notice: 'There was a problem restarting the workflow run' }
          format.json { render json: false }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_workflow_run
      @github_workflow_run = Github::WorkflowRun.new(@app.github_repo, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_workflow_run_params
      params.permit(:team_id, :app_id, :repository_repo, :workflow_id, :id)
    end
  end
end
