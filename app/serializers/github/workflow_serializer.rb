# frozen_string_literal: true

module Github
  class WorkflowSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :app, serializer: AppSerializer, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}"
      }
    }

    has_many :workflow_runs, id_method_name: :workflow_run_ids, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}/workflow_runs"
      }
    }
  end
end
