# frozen_string_literal: true

module Github
  class WorkflowRunSerializer < ::BaseSerializer
    attributes :id, :name, :node_id, :head_branch, :head_sha, :run_number, :event, :status, :conclusion, :workflow_id,
               :check_suite_id, :check_suite_node_id, :url, :html_url, :pull_requests, :created_at, :updated_at, :actor,
               :run_attempt, :run_started_at, :triggering_actor, :jobs_url, :logs_url, :check_suite_url, :artifacts_url,
               :cancel_url, :rerun_url, :previous_attempt_url, :workflow_url, :head_commit, :repository,
               :head_repository

    belongs_to :workflow
    has_many :workflow_run_jobs
  end
end
