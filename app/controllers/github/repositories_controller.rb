# frozen_string_literal: true

module Github
  # Handles displaying repository info for an app
  class RepositoriesController < BaseController
    # GET /github/repositories/1 or /github/repositories/1.json
    def show; end

    private

    # Only allow a list of trusted parameters through.
    def github_repository_params
      params.require(:github_repository).permit(:repo)
    end
  end
end
