# frozen_string_literal: true

module GitHub
  # Class representing a GitHub PullRequest
  class PullRequest
    attr_accessor :gh_info, :repo, :branch_name, :id

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @branch_name = @gh_info[:head][:ref]
    end

    def comments
      Octokit.pull_request_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def merged?
      Octokit.pull_merged?("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def workflow_runs
      GitHub::WorkflowRun.all_for_branch(@repo, @branch_name)
    end

    def self.all(repo, page_number = 1)
      Octokit.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })
    end
  end
end
