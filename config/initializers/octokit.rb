# frozen_string_literal: true

cache_stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false, store: Rails.cache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.configure do |config|
  config.access_token = ENV['GITHUB_ACCESS_TOKEN']
  config.middleware = cache_stack
  config.per_page = 20
  config.connection_options = {
    request: {
      open_timeout: 5,
      timeout: 5
    }
  }
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
  # @return [String] Workflow Run Job Logs
  # @see https://developer.github.com/v3/actions/workflow-runs/#get-a-workflow-run
  def workflow_run_job_logs(repo, id, options = {})
    response = get "#{Octokit::Repository.path repo}/actions/jobs/#{id}/logs", options
    if response.blank? && last_response&.status == 302
      get last_response.headers['Location']
    else
      response
    end
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
