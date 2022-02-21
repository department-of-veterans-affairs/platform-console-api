# frozen_string_literal: true

module Github
  # Class representing a Github Repository
  class Repository
    include Github::Pagination

    attr_accessor :repo, :octokit_client, :github

    def initialize(repo)
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.repository("#{GITHUB_ORGANIZATION}/#{@repo}")
    end

    # Lists all repositories for the organization.
    def self.all(page = 1)
      octokit_client = Octokit::Client.new
      response = {}
      response[:repositories] = octokit_client.organization_repositories(GITHUB_ORGANIZATION, page: page)

      response[:pages] = page_numbers(octokit_client)
      response
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
    def workflow_runs(page = 1)
      Github::WorkflowRun.all(@repo, page)
    end

    # List workflow runs for a branch on this repository.
    def branch_workflow_runs(branch_name, page = 1)
      Github::WorkflowRun.all_for_branch(@repo, branch_name, page)
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

    def deploy_workflow
      Github::Workflow.new(@repo, DEPLOY_WORKFLOW_FILE)
    rescue Octokit::NotFound
      nil
    end

    def workflow?(file_name)
      Github::Workflow.new(@repo, file_name)
      true
    rescue Octokit::NotFound
      false
    end

    def dispatch_pr_workflow
      inputs = { repo: "#{GITHUB_ORGANIZATION}/#{@repo}", file_name: DEPLOY_WORKFLOW_FILE }
      Github::Workflow.dispatch!('platform-console-api', CREATE_PR_WORKFLOW_FILE,
                                 'connect-app-to-github-deploy', { inputs: inputs })
    end

    def deploy!
      Github::Workflow.dispatch!(@repo, DEPLOY_WORKFLOW_FILE, 'master')
    end
  end
end
