# frozen_string_literal: true

module GitHub
  # Class representing a GitHub PullRequest
  class PullRequest
    include GitHub
    attr_accessor :gh_info, :repo, :branch_name, :pull_request_id

    def initialize(repo, pull_request_id)
      @repo = repo
      @gh_info = Octokit.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", pull_request_id)
      @branch_name = @gh_info[:head][:ref]
      @pull_request_id = pull_request_id
    end

    def comments
      Octokit.pull_request_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @pull_request_id)
    end

    def merged?
      Octokit.pull_merged?("#{GITHUB_ORGANIZATION}/#{@repo}", @pull_request_id)
    end

    def workflow_runs
      GitHub::WorkflowRun.all_for_branch(@repo, @branch_name)
    end

    def self.all(repo, page = 1)
      Octokit.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}", { page: })
    end
  end
end
