# frozen_string_literal: true

module Github
  # Class representing a Github PullRequest
  class PullRequest
    attr_accessor :id, :repo, :github, :branch_name

    def initialize(repo, id)
      @repo = repo
      @id = id
      @github = Octokit.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @branch_name = @github[:head][:ref]
    end

    def comments
      Octokit.pull_request_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def merged?
      Octokit.pull_merged?("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def workflow_runs
      Github::WorkflowRun.all_for_branch(@repo, @branch_name)
    end

    def self.all(repo, page_number = 1)
      Octokit.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })
    end
  end
end
