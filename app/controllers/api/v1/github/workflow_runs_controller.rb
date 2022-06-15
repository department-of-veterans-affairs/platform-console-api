# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying workflow run info for an app
      class WorkflowRunsController < BaseController
        before_action :set_github_workflow_run, only: %i[show update]
        before_action :set_all_workflows, only: %i[create]

        # GET /v1/teams/:team_id/apps/:app_id/workflow_runs
        def index
          @github_workflow_runs = ::Github::WorkflowRun.all(current_user.github_token, @github_repository.repo, @app.id)
          render json: ::Github::WorkflowRunSerializer.new(@github_workflow_runs[:objects]).serializable_hash
        end

        # GET /v1/teams/:team_id/apps/:app_id/workflow_runs/:id
        def show
          @jobs = @github_workflow_run.jobs[:objects]
          render json: ::Github::WorkflowRunSerializer.new(@jobs).serializable_hash
        end

        # POST /v1/teams/:team_id/apps/:app_id/workflow_runs
        def create
          options = {}
          options[:inputs] = github_workflow_run_params[:inputs] if github_workflow_run_params[:inputs].present?
          ::Github::Workflow.dispatch!(
            current_user.github_token, @app.github_repo, github_workflow_run_params[:workflow_id],
            github_workflow_run_params[:ref], options
          )
          render :show, json: true, status: :ok
        rescue Octokit::UnprocessableEntity => e
          render json: e.message, status: :unprocessable_entity
        end

        # PATCH /v1/teams/:team_id/apps/:app_id/workflow_runs/:id
        def update
          if @github_workflow_run.rerun!
            render json: true, status: :created
          else
            render json: false, status: :unprocessable_entity
          end
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_github_workflow_run
          @github_workflow_run = ::Github::WorkflowRun.new(current_user.github_token, @app.github_repo, params[:id],
                                                           @app.id)
        end

        # Only allow a list of trusted parameters through.
        def github_workflow_run_params
          params.permit(:team_id, :app_id, :repository_repo, :workflow_id, :id, :ref, inputs: [:environment])
        end

        def set_all_workflows
          if request.path.include?('deploy')
            workflow = @github_repository.deploy_workflow(@app.deploy_workflow)
            @all_workflows = [workflow.github]
            @inputs = workflow.inputs
          else
            @all_workflows = @github_repository.workflows[:objects]
          end
        end
      end
    end
  end
end
