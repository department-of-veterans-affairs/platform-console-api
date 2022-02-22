# frozen_string_literal: true

module Github
  # Class representing a Github PullRequest
  class PullRequest
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :github, :branch_name

    # Creates an Github::PullRequest object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the Pull Request
    #
    # @return [Github::PullRequest]
    # @see https://docs.github.com/en/rest/reference/pulls#get-a-pull-request
    def initialize(repo, id)
      @repo = repo
      @id = id
      @octokit_client = Octokit::Client.new
      @github = octokit_client.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @branch_name = @github[:head][:ref]
    end

    # List all Pull Requests associated with a repository
    #
    # @param repo [String] A GitHub repository
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Pull requests
    # @see https://docs.github.com/en/rest/reference/pulls#list-pull-requests
    def self.all(repo, page = 1)
      octokit_client = Octokit::Client.new
      response = {}
      response[:pull_requests] = octokit_client.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}", page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List a Pull Request's comments
    #
    # @return [Sawyer::Resource] Comments
    # @see https://docs.github.com/en/rest/reference/pulls#review-comments
    def comments
      @octokit_client.pull_request_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    # Check if a pull request is merged
    #
    # @return [Boolean] If it has been merged
    # @see https://docs.github.com/en/rest/reference/pulls#check-if-a-pull-request-has-been-merged
    def merged?
      @octokit_client.pull_merged?("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    # List Workflow Runs associated with a PRs branch
    #
    # @return [Sawyer::Resource] Workflow runs
    # @see https://docs.github.com/en/rest/reference/actions#list-repository-workflows
    def workflow_runs
      Github::WorkflowRun.all_for_branch(@repo, @branch_name)
    end
  end
end
