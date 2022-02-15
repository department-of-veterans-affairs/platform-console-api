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

    def self.all(repo, page_number = 1)
      Octokit.list_issues("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })
    end
  end
end
