# frozen_string_literal: true

module Github
  class PullRequestSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :app, serializer: AppSerializer, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}"
      }
    }
  end
end
