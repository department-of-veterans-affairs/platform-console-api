# frozen_string_literal: true

module Github
  # Handles displaying pull request info for an app
  class PullRequestsController < BaseController
    # GET /github/pull_requests or /github/pull_requests.json
    def index
      @curr_page = params.fetch(:page, 1)
      @github_pull_requests = Github::PullRequest.all(@app.github_repo, @current_page)
      set_pages
    end

    private

    def set_pages
      @last_page = @github_pull_requests.dig(:pages, :last)
      @next_page = @curr_page.to_i + 1 unless @curr_page == @last_page
      @prev_page = @curr_page.to_i - 1 unless @curr_page == 1
      @first_page = 1
    end
  end
end
