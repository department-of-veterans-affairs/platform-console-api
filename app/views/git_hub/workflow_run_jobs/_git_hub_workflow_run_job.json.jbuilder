# frozen_string_literal: true

json.extract! git_hub_workflow_run, :id, :created_at, :updated_at
json.url git_hub_workflow_run_url(git_hub_workflow_run, format: :json)
