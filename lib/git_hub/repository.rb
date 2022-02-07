# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Repository
  class Repository
    attr_accessor :gh_info, :repo

    def initialize(repo)
      @repo = repo
      @gh_info = Octokit.repository(repo_path(@repo))
    end

    def issues
      Octokit.issues(repo_path(@repo))
    end

    def pull_requests
      Octokit.pull_requests(repo_path(@repo))
    end

    def workflows
      Octokit.workflows(repo_path(@repo))
    end

    # List workflow runs for this repository.
    def workflow_runs
      Octokit.repository_workflow_runs(repo_path(@repo))
    end

    # List workflow runs for a branch on this repository.
    def branch_workflow_runs(branch_name)
      Octokit.repository_workflow_runs(repo_path(@repo), { branch: branch_name })
    end

    # Lists all repositories for the organization.
    def self.all
      Octokit.organization_repositories(GITHUB_ORGANIZATION)
    end
  end
end
