# frozen_string_literal: true

module GitHub
  # Handles displaying pull request info for an app
  class PullRequestsController < BaseController
    before_action :set_git_hub_pull_request, only: %i[show]

    # GET /git_hub/pull_requests or /git_hub/pull_requests.json
    def index
      @git_hub_pull_requests = GitHub::PullRequest.all
    end

    # GET /git_hub/pull_requests/1 or /git_hub/pull_requests/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_pull_request
      @git_hub_pull_request = GitHub::PullRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def git_hub_pull_request_params
      params.require(:git_hub_pull_request).permit(:show)
    end
  end
end
