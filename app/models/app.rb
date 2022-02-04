# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true

  GITHUB_ORGANIZATION = 'department-of-veterans-affairs'

  def github_repository
    Octokit.repository("#{GITHUB_ORGANIZATION}/#{github_repo_slug}")
  end

  def github_commit_history(branch = 'master')
    Octokit.commits("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", { branch: })
  end

  def github_pull_requests
    Octokit.pull_requests("#{GITHUB_ORGANIZATION}/#{github_repo_slug}")
  end

  def github_pull_request(pull_request_id)
    Octokit.pull_request("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", pull_request_id)
  end

  # Workflows
  def github_workflows
    Octokit.workflows("#{GITHUB_ORGANIZATION}/#{github_repo_slug}")
  end

  def github_workflow(workflow_id)
    Octokit.workflow("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", workflow_id)
  end

  def github_workflow_runs(workflow_id)
    Octokit.workflow_runs("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", workflow_id)
  end

  def github_workflow_run(workflow_run_id)
    Octokit.workflow_run("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", workflow_run_id)
  end

  def github_repository_workflow_runs(branch = nil)
    Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", { branch: })
  end

  def github_workflow_run_logs(workflow_run_id)
    Octokit.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", workflow_run_id)
  end

  def github_rerun_workflow_run(workflow_run_id)
    Octokit.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{github_repo_slug}", workflow_run_id)
  end
end
