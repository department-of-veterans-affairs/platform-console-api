# frozen_string_literal: true

module Github
  class WorkflowRunJobSerializer < ::BaseSerializer
    attributes :id, :run_id, :run_url, :run_attempt, :node_id, :head_sha, :url, :html_url, :status, :conclusion,
               :started_at, :completed_at, :name, :steps, :check_run_url, :labels, :runner_id, :runner_name,
               :runner_group_id, :runner_group_name

    belongs_to :workflow_run
  end
end
