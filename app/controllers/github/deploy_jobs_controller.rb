# frozen_string_literal: true

module Github
  # Handles displaying workflow run job info for an app
  class DeployJobsController < BaseController
    before_action :set_github_deploy_job, only: %i[show]

    # GET /github/workflow_runs/1 or /github/workflow_runs/1.json
    def show
      @github_deploy = Github::WorkflowRun.new(@app.github_repo_slug, params[:deploy_id])
      @all_jobs = @github_deploy.jobs
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy_job
      @github_deploy_job = Github::WorkflowRunJob.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_workflow_run_params
      params.fetch(:github_workflow_run_job, {})
    end
  end
end
