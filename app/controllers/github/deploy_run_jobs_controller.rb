# frozen_string_literal: true

module Github
  # Handles displaying deploy run job info for an app
  class DeployRunJobsController < BaseController
    before_action :set_github_deploy_run_job, only: %i[show]

    # GET /github/deploy_runs/1 or /github/deploy_runs/1.json
    def show
      @github_deploy_run = Github::DeployRun.new(@app.github_repo, @github_deploy_run_job.github[:run_id])
      @all_jobs = @github_deploy_run.jobs
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy_run_job
      @github_deploy_run_job = Github::DeployRunJob.new(@app.github_repo, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_deploy_run_params
      params.fetch(:github_deploy_run_job, {})
    end
  end
end
