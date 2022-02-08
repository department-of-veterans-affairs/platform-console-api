# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Repository
  class Repository
    include GitHub
    attr_accessor :gh_info, :repo

    def initialize(repo)
      @repo = repo
      @gh_info = Octokit.repository(repo_path(@repo))
    end

    def issues
      GitHub::Issue.all(@repo)
    end

    def pull_requests
      GitHub::PullRequest.all(@repo)
    end

    def workflows
      GitHub::Workflow.all(@repo)
    end

    # List all workflow runs for this repository.
    def all_workflow_runs
      GitHub::WorkflowRun.all(@repo)
    end

    # List workflow runs for a branch on this repository.
    def branch_workflow_runs(branch_name)
      GitHub::WorkflowRun.all_for_branch(@repo, branch_name)
    end

    # List runs for a particular workflow in this repository.
    def workflow_runs(workflow_id)
      GitHub::WorkflowRun.all_for_workflow(@repo, workflow_id)
    end

    # Lists all repositories for the organization.
    def self.all
      Octokit.organization_repositories(GITHUB_ORGANIZATION)
    end
  end
end
