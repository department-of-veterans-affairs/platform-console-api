# frozen_string_literal: true

json.extract! github_workflow, :id, :created_at, :updated_at
json.url github_workflow_url(github_workflow, format: :json)
