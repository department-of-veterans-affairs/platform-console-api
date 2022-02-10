# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Issue
  class Issue
    attr_accessor :gh_info, :repo, :issue_id

    def initialize(repo, issue_id)
      @repo = repo
      @gh_info = Octokit.issue("#{GITHUB_ORGANIZATION}/#{@repo}", issue_id)
      @issue_id = issue_id
    end

    def comments
      Octokit.issue_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @issue_id)
    end

    def self.all(repo)
      Octokit.issues("#{GITHUB_ORGANIZATION}/#{repo}")
    end
  end
end
