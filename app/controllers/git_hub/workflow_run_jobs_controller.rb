# frozen_string_literal: true

module GitHub
  # Handles displaying workflow run job info for an app
  class WorkflowRunJobsController < BaseController
    before_action :set_git_hub_workflow_run_job, only: %i[show]

    # GET /git_hub/workflow_runs/1 or /git_hub/workflow_runs/1.json
    def show
      @git_hub_workflow_run = GitHub::WorkflowRun.new(@app.github_repo_slug, params[:workflow_run_id])
      @all_jobs = @git_hub_workflow_run.jobs
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_workflow_run_job
      @git_hub_workflow_run_job = GitHub::WorkflowRunJob.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_workflow_run_params
      params.fetch(:git_hub_workflow_run_job, {})
    end
  end
end
