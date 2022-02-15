# frozen_string_literal: true

module GitHub
  # Handles displaying workflow run info for an app
  class WorkflowRunsController < BaseController
    before_action :set_git_hub_workflow_run, only: %i[show rerun]

    # GET /git_hub/workflow_runs or /git_hub/workflow_runs.json
    def index
      @git_hub_workflow_runs = GitHub::WorkflowRun.all
    end

    # GET /git_hub/workflow_runs/1 or /git_hub/workflow_runs/1.json
    def show
      @jobs = @git_hub_workflow_run.jobs
      @current_job = params[:job] || @jobs[:jobs].first[:name]
    end

    def new
      @workflows = @git_hub_repository.workflows
    end

    def rerun # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @git_hub_workflow_run.rerun!
          path = team_app_git_hub_repository_workflow_path(@team, @app, @app.github_repo_slug, params[:workflow_id])
          format.html { redirect_to path, notice: 'Workflow run was sucessfully restarted' }
          format.json { render json: true }
        else
          path = team_app_git_hub_repository_workflow_workflow_run_path(@team, @app, @app.github_repo_slug,
                                                                        params[:workflow_id], params[:id])
          format.html { redirect_to path, notice: 'There was a problem restarting the workflow run' }
          format.json { render json: false }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_workflow_run
      @git_hub_workflow_run = GitHub::WorkflowRun.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_workflow_run_params
      params.fetch(:git_hub_workflow_run, {})
    end
  end
end
