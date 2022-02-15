# frozen_string_literal: true

Octokit.configure do |config|
  config.access_token = ENV['GITHUB_ACCESS_TOKEN']
  config.per_page = 20
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
  def check_run_from_url(url, options = {})
    get url, options
  end
end
