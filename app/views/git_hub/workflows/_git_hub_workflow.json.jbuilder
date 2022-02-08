# frozen_string_literal: true

json.extract! git_hub_workflow, :id, :created_at, :updated_at
json.url git_hub_workflow_url(git_hub_workflow, format: :json)
