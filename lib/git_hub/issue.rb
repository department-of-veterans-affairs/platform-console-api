# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Issue
  class Issue
    attr_accessor :gh_info, :repo, :id

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.issue("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def comments
      Octokit.issue_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.all(repo)
      Octokit.issues("#{GITHUB_ORGANIZATION}/#{repo}")
    end
  end
end
