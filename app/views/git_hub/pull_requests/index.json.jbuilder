# frozen_string_literal: true

json.array! @git_hub_pull_requests, partial: 'git_hub_pull_requests/git_hub_pull_request', as: :git_hub_pull_request
