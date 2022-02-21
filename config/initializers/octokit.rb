# frozen_string_literal: true

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.configure do |config|
  config.access_token = ENV['GITHUB_ACCESS_TOKEN']
  config.per_page = 20
  config.middleware = stack
end

Octokit::Client::ActionsWorkflowRuns.class_eval do
  # Get a workflow run's jobs
  #
  # @param repo [Integer, String, Repository, Hash] A GitHub repository
  # @param id [Integer] Id of a workflow run
  #
  # @return [Sawyer::Resource] Run information
  # @see https://developer.github.com/v3/actions/workflow-runs/#get-a-workflow-run
  def workflow_run_jobs(repo, id, options = {})
    get "#{Octokit::Repository.path repo}/actions/runs/#{id}/jobs", options
  end

  # Get a workflow run job
  #
  # @param repo [Integer, String, Repository, Hash] A GitHub repository
  # @param id [Integer] Id of a workflow run job
  #
  # @return [Sawyer::Resource] Run information
  # @see https://developer.github.com/v3/actions/workflow-runs/#get-a-workflow-run
  def workflow_run_job(repo, id, options = {})
    get "#{Octokit::Repository.path repo}/actions/jobs/#{id}", options
  end

  # Get a workflow run job's logs
  #
  # @param repo [Integer, String, Repository, Hash] A GitHub repository
  # @param id [Integer] Id of a workflow run job
  #
  # @return [Sawyer::Resource] Run information
  # @see https://developer.github.com/v3/actions/workflow-runs/#get-a-workflow-run
  def workflow_run_job_logs(repo, id, options = {})
    get "#{Octokit::Repository.path repo}/actions/jobs/#{id}/logs", options
  end
end

Octokit::Client::Checks.class_eval do
  # Get a Check Run for a workflow run job
  #
  # @param url [String] A URL to the check run on GitHub's API
  #
  # @return [Sawyer::Resource] Check Run information
  # @see https://docs.github.com/en/rest/reference/checks#check-runs
  def check_run_from_url(url, options = {})
    get url, options
  end
end
