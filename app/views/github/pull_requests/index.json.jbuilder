# frozen_string_literal: true

json.array! @github_pull_requests[:pull_requests], partial: 'github/pull_requests/github_pull_request',
                                                   as: :github_pull_request
