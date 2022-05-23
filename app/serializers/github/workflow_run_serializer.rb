# frozen_string_literal: true

module Github
  class WorkflowRunSerializer < ::BaseSerializer
    attributes :repo, :github, :app_id

    belongs_to :workflow, id_method_name: :workflow_id
    has_many :workflow_run_jobs, id_method_name: :workflow_run_job_ids
  end
end
