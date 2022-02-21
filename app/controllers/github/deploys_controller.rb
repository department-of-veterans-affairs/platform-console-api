# frozen_string_literal: true

module Github
  # Handles displaying deploy info for an app repository
  class DeploysController < BaseController
    before_action :set_github_deploy, only: %i[show]

    def index
      @curr_page = params.fetch(:page, 1)
      @github_deploy_workflow = @github_repository.deploy_workflow
      if @github_deploy_workflow.present?
        @github_deploy_workflow_runs = @github_deploy_workflow.workflow_runs(params[:page] || 1).to_h
      end
      @next_page = @github_deploy_workflow_runs.dig(:pages, :next)
      @prev_page = @github_deploy_workflow_runs.dig(:pages, :prev)
      @first_page = @github_deploy_workflow_runs.dig(:pages, :first)
      @last_page = @github_deploy_workflow_runs.dig(:pages, :last)
    end

    def show
      @jobs = @github_deploy.jobs
    end

    def new; end

    def create; end

    def rerun; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy
      @github_deploy = Github::WorkflowRun.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_deploy_params
      params.require(:github_repository).permit(:repo)
    end
  end
end
