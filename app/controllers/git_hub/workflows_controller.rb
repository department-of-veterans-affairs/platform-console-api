# frozen_string_literal: true

module GitHub
  # Handles displaying workflow info for an app
  class WorkflowsController < BaseController
    before_action :set_git_hub_workflow, only: %i[show]

    # GET /git_hub/workflows or /git_hub/workflows.json
    def index
      @git_hub_workflows = @git_hub_repository.workflows
      @git_hub_workflow_runs = @git_hub_repository.workflow_runs
    end

    # GET /git_hub/workflows/1 or /git_hub/workflows/1.json
    def show
      @all_workflows = @git_hub_repository.workflows
      @git_hub_workflow_runs = @git_hub_workflow.workflow_runs
    end

    def new_dispatch
      @all_workflows = @git_hub_repository.workflows
    end

    def workflow_dispatch # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        GitHub::Workflow.dispatch!(@app.github_repo_slug, params[:workflow_id], params[:ref])
        format.html do
          redirect_to team_app_git_hub_repository_workflow_path(@app, @team,
                                                                @app.github_repo_slug, params[:workflow_id]),
                      notice: 'Workflow was successfully dispatched'
        end
        format.json { render :show, json: true, status: :ok }
      rescue Octokit::UnprocessableEntity => e
        @all_workflows = @git_hub_repository.workflows
        @error = e.message
        format.html { render :new_dispatch, status: :unprocessable_entity }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_workflow
      @git_hub_workflow = GitHub::Workflow.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_workflow_params
      params.fetch(:git_hub_workflow, {})
    end
  end
end
