# frozen_string_literal: true

module GitHub
  # Handles displaying workflow run info for an app
  class WorkflowRunsController < BaseController
    before_action :set_git_hub_workflow_run, only: %i[show]

    # GET /git_hub/workflow_runs or /git_hub/workflow_runs.json
    def index
      @git_hub_workflow_runs = GitHub::WorkflowRun.all
    end

    # GET /git_hub/workflow_runs/1 or /git_hub/workflow_runs/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_workflow_run
      @git_hub_workflow_run = GitHub::WorkflowRun.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_workflow_run_params
      params.fetch(:git_hub_workflow_run, {})
    end
  end
end
