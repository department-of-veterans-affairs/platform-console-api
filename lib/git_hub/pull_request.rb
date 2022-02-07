# frozen_string_literal: true

module GitHub
  # Class representing a GitHub PullRequest
  class PullRequest
    attr_accessor :gh_info, :repo, :branch_name

    def initialize(repo, pull_request_id)
      @repo = repo
      @gh_info = Octokit.pull_request("#{GITHUB_ORGANIZATION}/#{@repo}", pull_request_id)
      @branch_name = @gh_info[:head][:ref]
    end

    def self.all(repo)
      Octokit.pull_requests("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def workflow_runs
      GitHub::WorkflowRun.all_branch(@repo, @branch_name)
    end
  end
end
