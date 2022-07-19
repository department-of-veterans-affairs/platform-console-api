# frozen_string_literal: true

json.workflow_runs @github_workflow_runs[:objects].map(&:to_h)
