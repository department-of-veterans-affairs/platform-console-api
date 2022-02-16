# frozen_string_literal: true

json.extract! github_issue, :id, :show, :created_at, :updated_at
json.url github_issue_url(github_issue, format: :json)
