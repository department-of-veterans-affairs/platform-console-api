# frozen_string_literal: true

module GitHub
  # Base controller of shared methods for classes in GitHub Module
  class BaseController < ApplicationController
    before_action :authorize_session!
    before_action :set_team
    before_action :set_app
    before_action :set_git_hub_repository
    before_action :authorize_repo!

    private

    def set_git_hub_repository
      @git_hub_repository = GitHub::Repository.new(@app.github_repo_slug)
    end

    def authorize_repo!
      return if params[:repo] || params[:repository_repo] == @app.github_repo_slug

      respond_to do |format|
        flash[:error] = 'Unauthorized'
        format.html { redirect_to root_path }
      end
    end

    def set_team
      @team = Team.find(params[:team_id])
    end

    # Find the team app
    def set_app
      @app = @team.apps.find(params[:app_id])
    end
  end
end
