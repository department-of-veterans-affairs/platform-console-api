# frozen_string_literal: true

module Github
  class WorkflowSerializer < ::BaseSerializer
    attributes :repo, :github

    has_many :workflow_runs, id_method_name: :workflow_run_ids
  end
end
