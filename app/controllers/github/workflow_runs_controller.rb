# frozen_string_literal: true

module Github
  # Handles displaying workflow run info for an app
  class WorkflowRunsController < BaseController
    before_action :set_github_workflow_run, only: %i[show update]
    before_action :set_all_workflows, only: %i[new create]

    # GET /github/workflow_runs or /github/workflow_runs.json
    def index
      @github_workflow_runs = Github::WorkflowRun.all(current_user.github_token, @github_repository.repo)
    end

    # GET /github/workflow_runs/1 or /github/workflow_runs/1.json
    def show
      @jobs = @github_workflow_run.jobs
    end

    def new; end

    def create # rubocop:disable Metrics/MethodLength
      respond_to do |format|
        options = {}
        options[:inputs] = { inputs: github_workflow_run_params[:inputs] } if github_workflow_run_params[:inputs]
        Github::Workflow.dispatch!(
          current_user.github_token, @app.github_repo, github_workflow_run_params[:workflow_id],
          github_workflow_run_params[:ref], options
        )
        format.html do
          if request.path.include?('deploy')
            redirect_to team_app_deploy_path(@app, @team, github_workflow_run_params[:workflow_id]),
                        notice: 'Deploy was successfully dispatched'
          else
            redirect_to team_app_workflow_path(@app, @team, github_workflow_run_params[:workflow_id]),
                        notice: 'Workflow was successfully dispatched'
          end
        end
        format.json { render :show, json: true, status: :ok }
      rescue Octokit::UnprocessableEntity => e
        @error = e.message
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end

    def update
      respond_to do |format|
        if @github_workflow_run.rerun!
          path = team_app_workflow_path(@team, @app, github_workflow_run_params[:workflow_id])
          format.html { redirect_to path, notice: 'Workflow run was sucessfully restarted' }
          format.json { render json: true }
        else
          path = team_app_workflow_run_path(@team, @app, github_workflow_run_params[:id])
          format.html { redirect_to path, notice: 'There was a problem restarting the workflow run' }
          format.json { render json: false }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_workflow_run
      @github_workflow_run = Github::WorkflowRun.new(current_user.github_token, @app.github_repo, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_workflow_run_params
      params.permit(:team_id, :app_id, :repository_repo, :workflow_id, :id, :ref, inputs: [:environment])
    end

    def set_all_workflows
      @all_workflows = if request.path.include?('deploy')
                         [@github_repository.deploy_workflow.github]
                       else
                         @github_repository.workflows[:workflows]
                       end
    end
  end
end
