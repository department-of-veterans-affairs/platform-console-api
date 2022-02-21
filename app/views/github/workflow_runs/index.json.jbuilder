# frozen_string_literal: true

json.array! @github_workflow_runs[:workflow_runs], partial: 'github/workflow_runs/github_workflow_run',
                                                   as: :workflow_run
