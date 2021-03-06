# frozen_string_literal: true

module Github
  # Handles displaying workflow info for an app
  class WorkflowsController < BaseController
    before_action :set_github_workflow, only: %i[show]
    before_action :set_github_workflow_runs, only: %i[index]

    # GET /github/workflows or /github/workflows.json
    def index
      if @app.deploy_workflow.present? && request.path.include?('deploy')
        deploy_workflow = @github_repository.deploy_workflow(@app.deploy_workflow)
        redirect_to team_app_deploy_path(@team, @app, deploy_workflow.id) if deploy_workflow
      else
        @current_page = params.fetch(:page, 1)
        @github_workflows = @github_repository.workflows[:objects]
        set_pages
      end
    end

    # GET /github/workflows/1 or /github/workflows/1.json
    def show
      @current_page = params.fetch(:page, 1)
      @all_workflows = if request.path.include?('deploy')
                         [@github_repository.deploy_workflow(@app.deploy_workflow)]
                       else
                         @github_repository.workflows[:objects]
                       end
      @github_workflow_runs = @github_workflow.workflow_runs(params[:page] || 1, { branch: params[:ref] }).to_h
      set_pages
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_workflow
      @github_workflow = Github::Workflow.new(current_user.github_token, @app.github_repo, params[:id], @app.id)
    end

    # Only allow a list of trusted parameters through.
    def github_workflow_params
      params.permit(:team_id, :app_id, :repository_repo, :ref, :workflow_id)
    end

    def set_pages
      @next_page = @github_workflow_runs.dig(:pages, :next)
      @prev_page = @github_workflow_runs.dig(:pages, :prev)
      @first_page = @github_workflow_runs.dig(:pages, :first)
      @last_page = @github_workflow_runs.dig(:pages, :last)
    end

    def set_github_workflow_runs
      @github_workflow_runs =
        if params[:ref].present?
          @github_repository.branch_workflow_runs(params[:ref], params[:page] || 1).to_h
        else
          @github_repository.workflow_runs(params[:page] || 1).to_h
        end
    end
  end
end
