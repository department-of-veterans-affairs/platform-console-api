# frozen_string_literal: true

module Github
  class PullRequestSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :app, links: {
      related: lambda { |pull_request|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(repository.pull_request)}/apps/#{pull_request.app_id}"
      }
    }
  end
end
