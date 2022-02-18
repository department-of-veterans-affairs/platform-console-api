# frozen_string_literal: true

module Github
  # Handles displaying pull request info for an app
  class PullRequestsController < BaseController
    before_action :set_github_pull_request, only: %i[show]

    # GET /github/pull_requests or /github/pull_requests.json
    def index
      @curr_page = params.fetch(:page, 1)
      @github_pull_requests = Github::PullRequest.all(@app.github_repo_slug, @current_page)
      @last_page = @github_pull_requests.dig(:pages, :last)
      @next_page = @curr_page.to_i + 1 unless @curr_page == @last_page
      @prev_page = @curr_page.to_i - 1 unless @curr_page == 1
      @first_page = 1
    end

    # GET /github/pull_requests/1 or /github/pull_requests/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_pull_request
      @github_pull_request = Github::PullRequest.new(@app.github_repo_slug, params[:number])
    end

    # Only allow a list of trusted parameters through.
    def github_pull_request_params
      params.require(:github_pull_request).permit(:show)
    end
  end
end
