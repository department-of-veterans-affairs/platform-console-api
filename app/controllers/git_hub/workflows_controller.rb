# frozen_string_literal: true

module GitHub
  # Handles displaying workflow info for an app
  class WorkflowsController < ApplicationController
    before_action :set_git_hub_workflow, only: %i[show]

    # GET /git_hub/workflows or /git_hub/workflows.json
    def index
      @git_hub_workflows = GitHub::Workflow.all
    end

    # GET /git_hub/workflows/1 or /git_hub/workflows/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_workflow
      @git_hub_workflow = GitHub::Workflow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_workflow_params
      params.fetch(:git_hub_workflow, {})
    end
  end
end
