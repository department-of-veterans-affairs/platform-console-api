# frozen_string_literal: true

json.extract! git_hub_pull_request, :id, :show, :created_at, :updated_at
json.url git_hub_pull_request_url(git_hub_pull_request, format: :json)
