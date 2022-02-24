# frozen_string_literal: true

module Github
  # Handles displaying workflow run job info for an app
  class WorkflowRunJobsController < BaseController
    before_action :set_github_workflow_run_job, only: %i[show]

    # GET /github/workflow_runs/1 or /github/workflow_runs/1.json
    def show
      @github_workflow_run = Github::WorkflowRun.new(@app.github_repo, params[:workflow_run_id])
      @all_jobs = @github_workflow_run.jobs
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_workflow_run_job
      @github_workflow_run_job = Github::WorkflowRunJob.new(@app.github_repo, params[:id])
    end
  end
end
