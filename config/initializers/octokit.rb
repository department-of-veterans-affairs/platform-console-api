# frozen_string_literal: true

Octokit.configure do |config|
  config.access_token = ENV.fetch 'GITHUB_ACCESS_TOKEN'
end
