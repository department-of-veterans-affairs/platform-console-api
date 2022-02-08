# frozen_string_literal: true

json.array! @git_hub_workflow_runs, partial: 'git_hub_workflow_runs/git_hub_workflow_run', as: :git_hub_workflow_run
