# frozen_string_literal: true

json.array! @github_pull_requests, partial: 'github_pull_requests/github_pull_request', as: :github_pull_request
