# frozen_string_literal: true

json.pull_requests @github_pull_requests[:objects].map(&:to_h)
