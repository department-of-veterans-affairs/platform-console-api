# frozen_string_literal: true

json.extract! github_pull_request, :id, :show, :created_at, :updated_at
json.url github_pull_request_url(github_pull_request, format: :json)
