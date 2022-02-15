# frozen_string_literal: true

json.extract! git_hub_issue, :id, :show, :created_at, :updated_at
json.url git_hub_issue_url(git_hub_issue, format: :json)
