# frozen_string_literal: true

Octokit.configure do |config|
  config.access_token = ENV['GITHUB_ACCESS_TOKEN']
end
