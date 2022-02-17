# frozen_string_literal: true

module Github
  # Handles displaying workflow info for an app
  class WorkflowsController < BaseController
    before_action :set_github_workflow, only: %i[show]

    # GET /github/workflows or /github/workflows.json
    def index
      @curr_page = params.fetch(:page, 1)
      @github_workflows = @github_repository.workflows
      @github_workflow_runs = @github_repository.workflow_runs(params[:page] || 1).to_h
      @next_page = @github_workflow_runs.dig(:pages, :next)
      @prev_page = @github_workflow_runs.dig(:pages, :prev)
      @first_page = @github_workflow_runs.dig(:pages, :first)
      @last_page = @github_workflow_runs.dig(:pages, :last)
    end

    # GET /github/workflows/1 or /github/workflows/1.json
    def show
      @curr_page = params.fetch(:page, 1)
      @all_workflows = @github_repository.workflows
      @github_workflow_runs = @github_workflow.workflow_runs(params[:page] || 1).to_h
      @next_page = @github_workflow_runs.dig(:pages, :next)
      @prev_page = @github_workflow_runs.dig(:pages, :prev)
      @first_page = @github_workflow_runs.dig(:pages, :first)
      @last_page = @github_workflow_runs.dig(:pages, :last)
    end

    def new_dispatch
      @all_workflows = @github_repository.workflows
    end

    def workflow_dispatch # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        Github::Workflow.dispatch!(@app.github_repo_slug, params[:workflow_id], params[:ref])
        format.html do
          redirect_to team_app_github_repository_workflow_path(@app, @team,
                                                               @app.github_repo_slug, params[:workflow_id]),
                      notice: 'Workflow was successfully dispatched'
        end
        format.json { render :show, json: true, status: :ok }
      rescue Octokit::UnprocessableEntity => e
        @all_workflows = @github_repository.workflows
        @error = e.message
        format.html { render :new_dispatch, status: :unprocessable_entity }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_workflow
      @github_workflow = Github::Workflow.new(@app.github_repo_slug, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_workflow_params
      params.fetch(:github_workflow, {})
    end
  end
end
