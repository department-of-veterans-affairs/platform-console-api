# frozen_string_literal: true

module Github
  class RepositorySerializer < ::BaseSerializer
    set_id :repo
    attributes :repo, :github, :app_id

    has_many :workflows, id_method_name: :workflow_ids, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}/workflows"
      }
    }
  end
end
