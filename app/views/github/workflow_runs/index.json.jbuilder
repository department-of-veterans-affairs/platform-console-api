# frozen_string_literal: true

json.array! @github_workflow_runs, partial: 'github_workflow_runs/github_workflow_run', as: :github_workflow_run
