# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Issue
  class Issue
    include GitHub
    attr_accessor :gh_info, :repo, :issue_id

    def initialize(repo, issue_id)
      @repo = repo
      @gh_info = Octokit.issue(repo_path(repo), issue_id)
      @issue_id = issue_id
    end

    def comments
      Octokit.issue_comments(repo_path(@repo), @issue_id)
    end

    def self.all(repo)
      Octokit.issues(repo_path(repo))
    end
  end
end
