# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying workflow info for an app
      class WorkflowsController < BaseController
        before_action :set_github_workflow, only: %i[show]

        # GET /v1/teams/:team_id/apps/:app_id/workflows
        def index
          if @app.deploy_workflow.present? && request.path.include?('deploy')
            deploy_workflow = @github_repository.deploy_workflow(@app.deploy_workflow)
            render json: ::Github::WorkflowSerializer.new(deploy_workflow).serializable_hash
          else
            @current_page = params.fetch(:page, 1)
            @github_workflows = @github_repository.workflows
            render json: ::Github::WorkflowSerializer.new(
              @github_workflows[:objects],
              collection_options(@github_workflows[:pages])
            ).serializable_hash
          end
        end

        # GET /v1/teams/:team_id/apps/:app_id/workflows/:id
        def show
          render json: ::Github::WorkflowSerializer.new(@all_workflows).serializable_hash
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_github_workflow
          @github_workflow = ::Github::Workflow.new(current_user.github_token, @app.github_repo, params[:id], @app.id)
        end

        # Only allow a list of trusted parameters through.
        def github_workflow_params
          params.permit(:team_id, :app_id, :repository_repo, :ref, :workflow_id)
        end
      end
    end
  end
end
