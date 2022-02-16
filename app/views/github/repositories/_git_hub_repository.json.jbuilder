# frozen_string_literal: true

json.extract! github_repository, :id, :created_at, :updated_at
json.url github_repository_url(github_repository, format: :json)
