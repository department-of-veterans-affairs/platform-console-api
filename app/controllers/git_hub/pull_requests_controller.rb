# frozen_string_literal: true

module GitHub
  # Handles displaying pull request info for an app
  class PullRequestsController < BaseController
    before_action :set_git_hub_pull_request, only: %i[show]

    # GET /git_hub/pull_requests or /git_hub/pull_requests.json
    def index
      @current_page = params[:page] || 1
      @git_hub_pull_requests = @git_hub_repository.pull_requests(@current_page)
      @next_page = @current_page + 1 unless @git_hub_pull_requests.count < 30
      @previous_page = @current_page - 1 unless @current_page == 1
    end

    # GET /git_hub/pull_requests/1 or /git_hub/pull_requests/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_pull_request; end

    # Only allow a list of trusted parameters through.
    def git_hub_pull_request_params
      params.require(:git_hub_pull_request).permit(:show)
    end
  end
end
