# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying pull request info for an app
      class PullRequestsController < BaseController
        # GET /v1/teams/:team_id/apps/:app_id/pull_requests
        def index
          @current_page = params.fetch(:page, 1)
          @pull_requests = ::Github::PullRequest.all(current_user.github_token, @app.github_repo, @app.id)
          render json: ::Github::PullRequestSerializer.new(@pull_requests[:objects],
                                                           collection_options(@pull_requests[:pages])).serializable_hash
        end
      end
    end
  end
end
