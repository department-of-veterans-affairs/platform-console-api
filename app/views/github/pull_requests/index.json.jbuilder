# frozen_string_literal: true

json.pull_requests @github_pull_requests[:pull_requests].map(&:to_h)
