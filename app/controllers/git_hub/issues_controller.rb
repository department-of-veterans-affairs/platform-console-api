# frozen_string_literal: true

module GitHub
  # Handles displaying pull request info for an app
  class IssuesController < BaseController
    before_action :set_git_hub_issue, only: %i[show]

    # GET /git_hub/issues or /git_hub/issues.json
    def index
      @current_page = params[:page] || 1
      @git_hub_issues = @git_hub_repository.issues(@current_page)
      @next_page = @current_page + 1 unless @git_hub_issues.count < 30
      @previous_page = @current_page - 1 unless @current_page == 1
    end

    # GET /git_hub/issues/1 or /git_hub/issues/1.json
    def show; end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_git_hub_issue; end

    # Only allow a list of trusted parameters through.
    def git_hub_issue_params
      params.require(:git_hub_issue).permit(:show)
    end
  end
end
