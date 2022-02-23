# frozen_string_literal: true

module Github
  # Handles displaying deploy info for an app
  class DeploysController < BaseController
    before_action :set_github_deploy, only: %i[show]

    # GET /github/deploys or /github/deploys.json
    def index
      @curr_page = params.fetch(:page, 1)
      @github_deploy = Github::Deploy.new(@app.github_repo)
      @github_deploy_runs = @github_deploy&.deploy_runs
      set_pages if @github_deploy_runs
    end

    # GET /github/deploys/1 or /github/deploys/1.json
    def show
      @curr_page = params.fetch(:page, 1)
      @github_deploy_runs = @github_deploy.deploy_runs(params[:page] || 1).to_h
      set_pages
    end

    def new
      @github_deploy = Github::Deploy.new(@app.github_repo)
    end

    def deploy_dispatch # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        Github.deploy.dispatch!(@app.github_repo, params[:deploy_id], params[:ref])
        format.html do
          redirect_to team_app_github_repository_deploy_path(@app, @team,
                                                             @app.github_repo, params[:deploy_id]),
                      notice: 'deploy was successfully dispatched'
        end
        format.json { render :show, json: true, status: :ok }
      rescue Octokit::UnprocessableEntity => e
        @all_deploys = @github_repository.deploys
        @error = e.message
        format.html { render :new_dispatch, status: :unprocessable_entity }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_deploy
      @github_deploy = Github::Deploy.new(@app.github_repo)
    end

    # Only allow a list of trusted parameters through.
    def github_deploy_params
      params.fetch(:github_deploy, {})
    end

    def set_pages
      @next_page = @github_deploy_runs.dig(:pages, :next)
      @prev_page = @github_deploy_runs.dig(:pages, :prev)
      @first_page = @github_deploy_runs.dig(:pages, :first)
      @last_page = @github_deploy_runs.dig(:pages, :last)
    end
  end
end
