# frozen_string_literal: true

module Github
  # Handles displaying deploy info for an app
  class DeploysController < BaseController
    before_action :set_github_deploy, only: %i[index show]

    # GET /github/deploys or /github/deploys.json
    def index
      @curr_page = params.fetch(:page, 1)
      @github_deploy_runs = @github_deploy&.deploy_runs(params[:page] || 1)&.to_h
      set_pages if @github_deploy_runs
    end

    # GET /github/deploys/1 or /github/deploys/1.json
    def show
      @curr_page = params.fetch(:page, 1)
      @github_deploy_runs = @github_deploy.deploy_runs(params[:page] || 1).to_h
      set_pages
    end

    def new
      @github_deploy = Github::Deploy.new(current_user.github_token, @app.github_repo)
    end

    def deploy # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      respond_to do |format|
        Github::Deploy.dispatch!(current_user.github_token, @app.github_repo,
                                 github_deploy_params[:workflow_id], github_deploy_params[:ref],
                                 { inputs: github_deploy_params[:inputs] })
        format.html do
          redirect_to team_app_deploy_path(@app, @team, github_deploy_params[:workflow_id]),
                      notice: 'deploy was successfully dispatched'
        end
        format.json { render :show, json: true, status: :ok }
      rescue Octokit::UnprocessableEntity => e
        @error = e.message
        format.html do
          redirect_to team_app_deploy_path(@app, @team, github_deploy_params[:workflow_id]),
                      alert: @error
        end
        format.json { render json: false, status: :unprocessable_entity }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy
      @github_deploy = Github::Deploy.new(current_user.github_token, @app.github_repo)
    rescue Octokit::NotFound
      @github_deploy = nil
    end

    # Only allow a list of trusted parameters through.
    def github_deploy_params
      params.permit(:ref, :workflow_id, inputs: [:environment])
    end

    def set_pages
      @next_page = @github_deploy_runs.dig(:pages, :next)
      @prev_page = @github_deploy_runs.dig(:pages, :prev)
      @first_page = @github_deploy_runs.dig(:pages, :first)
      @last_page = @github_deploy_runs.dig(:pages, :last)
    end
  end
end
