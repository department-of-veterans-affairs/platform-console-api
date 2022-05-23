# frozen_string_literal: true

module Github
  class WorkflowRunJobSerializer < ::BaseSerializer
    attributes :repo, :github

    belongs_to :workflow_run, id_method_name: :workflow_run_id
  end
end
