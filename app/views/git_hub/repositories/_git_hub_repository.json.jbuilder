# frozen_string_literal: true

json.extract! git_hub_repository, :id, :created_at, :updated_at
json.url git_hub_repository_url(git_hub_repository, format: :json)
