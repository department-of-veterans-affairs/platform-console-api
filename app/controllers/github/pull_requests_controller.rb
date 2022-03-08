# frozen_string_literal: true

module Github
  # Handles displaying pull request info for an app
  class PullRequestsController < BaseController
    # GET /github/pull_requests or /github/pull_requests.json
    def index
      @current_page = params.fetch(:page, 1)
      @github_pull_requests = Github::PullRequest.all(current_user.github_token, @app.github_repo, @current_page)
      set_pages
    end

    private

    def set_pages
      @last_page = @github_pull_requests.dig(:pages, :last)
      @next_page = @current_page.to_i + 1 unless @current_page == @last_page
      @prev_page = @current_page.to_i - 1 unless @current_page == 1
      @first_page = 1
    end
  end
end
