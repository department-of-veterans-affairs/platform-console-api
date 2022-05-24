# frozen_string_literal: true

module Github
  class WorkflowRunSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    # rubocop:disable Layout/LineLength
    belongs_to :workflow, id_method_name: :workflow_id, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}/workflows/#{object.github.workflow_id}"
      }
    }
    # rubocop:enable Layout/LineLength
    has_many :workflow_run_jobs, id_method_name: :jobs_ids, links: {
      related: lambda { |object|
        "#{api_path}/teams/#{team_id_from_app_id(object.app_id)}/apps/#{object.app_id}/workflow_run_jobs"
      }
    }
  end
end
