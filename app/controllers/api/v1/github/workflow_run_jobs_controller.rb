# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying workflow run job info for an app
      class WorkflowRunJobsController < BaseController
        before_action :set_github_workflow_run_job, only: %i[show]

        # GET /v1/teams/:team_id/apps/:app_id/workflow_run_jobs/:id
        def show
          render json: ::Github::WorkflowRunJobSerializer.new(@github_workflow_run_job).serializable_hash.to_json
        end

        private

        def set_github_workflow_run_job
          @github_workflow_run_job = ::Github::WorkflowRunJob.new(current_user.github_token, @app.github_repo,
                                                                  params[:id], @app.id)
        end
      end
    end
  end
end
