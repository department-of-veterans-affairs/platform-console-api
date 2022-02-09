# frozen_string_literal: true

module GitHub
  class RepositoriesController < ApplicationController
    before_action :set_git_hub_repository, only: %i[show]

    # GET /git_hub/repositories/1 or /git_hub/repositories/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_repository
      @git_hub_repository = GitHub::Repository.new(params[:repo])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_repository_params
      params.require(:git_hub_repository).permit(:repo)
    end
  end
end
