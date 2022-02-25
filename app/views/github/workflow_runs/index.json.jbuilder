# frozen_string_literal: true

json.workflow_runs @github_workflow_runs[:workflow_runs].map(&:to_h)
