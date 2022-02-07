# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Repository
  class Repository
    attr_accessor :gh_info, :repo

    def initialize(repo)
      @repo = repo
      @gh_info = Octokit.repository("#{GITHUB_ORGANIZATION}/#{@repo}")
    end

    def pull_requests
      GitHub::PullRequest.all(@repo)
    end

    def workflows
      GitHub::Workflow.all(@repo)
    end
  end
end
