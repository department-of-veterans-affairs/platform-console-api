# frozen_string_literal: true

module Api
  module V1
    module Github
      # Handles displaying pull request info for an app
      class RepositoriesController < BaseController
        def show
          @repository = ::Github::Repository.new(params[:acces_token], params[:repo], 'app_id')
          render json: ::Github::PullRequestSerializer.new(@pull_requests[:pull_requests])
        end

        private

        # Only allow a list of trusted parameters through.
        def repository_params
          params.require(:repo).permit(:access_token)
        end
      end
    end
  end
end
