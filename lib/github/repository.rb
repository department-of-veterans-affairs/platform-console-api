# frozen_string_literal: true

module Github
  # Class representing a Github Repository
  class Repository
    include Github
    attr_accessor :repo, :github

    def initialize(repo)
      @repo = repo
      @github = Octokit.repository("#{GITHUB_ORGANIZATION}/#{@repo}")
    end

    def issues(page = 1)
      Github::Issue.all(@repo, page)
    end

    def pull_requests(page = 1)
      Github::PullRequest.all(@repo, page)
    end

    def workflows
      Github::Workflow.all(@repo)
    end

    # List all workflow runs for this repository.
    def workflow_runs
      Github::WorkflowRun.all(@repo)
    end

    # List workflow runs for a branch on this repository.
    def branch_workflow_runs(branch_name)
      Github::WorkflowRun.all_for_branch(@repo, branch_name)
    end

    # List runs for a particular workflow in this repository.
    def workflow_run(workflow_id)
      Github::WorkflowRun.all_for_workflow(@repo, workflow_id)
    end

    # Returns the readme for the repository.
    def readme
      content = Octokit.readme("#{GITHUB_ORGANIZATION}/#{@repo}").content
      Base64.decode64(content)
    end

    # Lists all repositories for the organization.
    def self.all
      Octokit.organization_repositories(GITHUB_ORGANIZATION)
    end
  end
end
