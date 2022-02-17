# frozen_string_literal: true

module Github
  # Class representing a Github PullRequest
  class PullRequest
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :github, :branch_name

    def initialize(repo, id)
      @repo = repo
      @id = id
      @octokit_client = Octokit::Client.new
      @github = octokit_client.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @branch_name = @github[:head][:ref]
    end

    def comments
      @octokit_client.pull_request_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def merged?
      @octokit_client.pull_merged?("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def workflow_runs
      Github::WorkflowRun.all_for_branch(@repo, @branch_name)
    end

    def self.all(repo, page = 1)
      octokit_client = Octokit::Client.new
      response = {}
      response[:pull_requests] = octokit_client.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}", page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end
  end
end
