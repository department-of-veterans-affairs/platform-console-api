# frozen_string_literal: true

json.extract! github_workflow_run, :id, :created_at, :updated_at
json.url github_workflow_run_url(github_workflow_run, format: :json)
