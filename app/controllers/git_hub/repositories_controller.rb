# frozen_string_literal: true

module GitHub
  # Handles displaying repository info for an app
  class RepositoriesController < BaseController
    before_action :set_git_hub_repository

    # GET /git_hub/repositories/1 or /git_hub/repositories/1.json
    def show; end

    private

    def set_git_hub_repository
      @git_hub_repository = GitHub::Repository.new(@app.github_repo_slug)
    end

    # Only allow a list of trusted parameters through.
    def git_hub_repository_params
      params.require(:git_hub_repository).permit(:repo)
    end
  end
end
