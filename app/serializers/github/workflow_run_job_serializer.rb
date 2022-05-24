# frozen_string_literal: true

module Github
  class WorkflowRunJobSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :workflow_run, id_method_name: :workflow_run_id, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}/workflow_runs"
      }
    }

    belongs_to :app, serializer: AppSerializer, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}"
      }
    }
  end
end
