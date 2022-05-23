# frozen_string_literal: true

module Github
  class WorkflowSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :app, serializer: AppSerializer, links: {
      related: lambda { |workflow|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(workflow.app_id)}/apps/#{workflow.app_id}"
      }
    }

    has_many :workflow_runs, id_method_name: :workflow_run_ids, links: {
      related: lambda { |workflow|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(workflow.app_id)}/apps/#{workflow.app_id}/workflow_runs"
      }
    }
  end
end
