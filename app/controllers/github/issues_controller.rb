# frozen_string_literal: true

module Github
  # Handles displaying pull request info for an app
  class IssuesController < BaseController
    before_action :set_github_issue, only: %i[show]

    # GET /github/issues or /github/issues.json
    def index
      @current_page = params[:page] || 1
      @github_issues = @github_repository.issues(@current_page)
      @next_page = @current_page + 1 unless @github_issues.count < 30
      @previous_page = @current_page - 1 unless @current_page == 1
    end

    # GET /github/issues/1 or /github/issues/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_github_issue; end

    # Only allow a list of trusted parameters through.
    def github_issue_params
      params.require(:github_issue).permit(:show)
    end
  end
end
