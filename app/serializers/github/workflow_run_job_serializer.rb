# frozen_string_literal: true

module Github
  class WorkflowRunJobSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :workflow_run, id_method_name: :workflow_run_id, links: {
      related: lambda { |workflow_run_job|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(workflow_run_job.app_id)}/apps/#{workflow_run_job.app_id}/workflow_runs"
      }
    }

    belongs_to :app, serializer: AppSerializer, links: {
      related: lambda { |workflow_run_job|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(workflow_run_job.app_id)}/apps/#{workflow_run_job.app_id}"
      }
    }
  end
end
