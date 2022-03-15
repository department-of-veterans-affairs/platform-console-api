# frozen_string_literal: true

module Github
  # Class representing a Github Repository
  class Repository
    include Github::Pagination
    include Github::Inspect

    attr_accessor :access_token, :repo, :octokit_client, :github

    # Creates a Github::Repository object with the github response attached
    #
    # @param repo [String] A GitHub repository
    #
    # @return [Github::Repository]
    # @see https://docs.github.com/en/rest/reference/repos#get-a-repository
    def initialize(access_token, repo)
      @access_token = access_token
      @repo = repo
      @octokit_client = Octokit::Client.new(access_token: access_token)
      @github = octokit_client.repository(repo)
    end

    # Get all repositories in an organization
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Repositories
    # @see https://docs.github.com/en/rest/reference/repos#list-organization-repositories
    def self.all(access_token, page = 1)
      octokit_client = Octokit::Client.new(access_token: access_token)
      response = {}
      response[:repositories] = octokit_client.organization_repositories(GITHUB_ORGANIZATION, page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List all issues in a repository
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Issues
    # @see https://docs.github.com/en/rest/reference/issues#list-repository-issues
    def issues(page = 1)
      Github::Issue.all(access_token, repo, page)
    end

    # List all pull requests in a repository
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Pull Requests
    # @see https://docs.github.com/en/rest/reference/pulls#list-pull-requests
    def pull_requests(page = 1)
      Github::PullRequest.all(access_token, repo, page)
    end

    # List all repository workflows
    #
    # @return [Sawyer::Resource] Workflows
    # @see https://docs.github.com/en/rest/reference/actions#list-repository-workflows
    def workflows
      Github::Workflow.all(access_token, repo)
    end

    # List all repository workflows runs
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflows
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
    def workflow_runs(page = 1)
      Github::WorkflowRun.all(access_token, repo, page)
    end

    # List all repository workflows runs associated to a branch in this repo
    #
    # @param branch_name [String] Branch name
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflows
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
    def branch_workflow_runs(branch_name, page = 1)
      Github::WorkflowRun.all_for_branch(access_token, repo, branch_name, page)
    end

    # List runs for a particular workflow in this repository.
    #
    # @param workflow_id [Integer] ID of the workflow
    #
    # @return [Sawyer::Resource] Workflow runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs
    def workflow_run(workflow_id)
      Github::WorkflowRun.all_for_workflow(access_token, repo, workflow_id)
    end

    # Get the deploy workflow in a repository
    #
    # @return [Sawyer::Resource, nil] The deploy workflow or nil if it doesnt exist
    def deploy_workflow
      Github::Workflow.new(access_token, repo, DEPLOY_WORKFLOW_FILE)
    rescue Octokit::NotFound
      nil
    end

    # Dispatches a workflow on platform-console-api that will create a new PR on
    # the repository with the new deploy workflow file.
    #
    # @return [Pull Request] The newly created pull request
    def create_deploy_workflow_pr
      branch_name = 'gha-add-deploy-template-workflow'
      default_branch_sha = octokit_client.ref(@repo, "heads/#{@github.default_branch}").object.sha
      message = "Add #{DEPLOY_WORKFLOW_FILE} workflow file"
      Github::PullRequest.create_from_new_branch(
        access_token, repo, branch_name, default_branch_sha, message, ".github/workflows/#{DEPLOY_WORKFLOW_FILE}"
      )
    end
  end
end
