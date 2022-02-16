# frozen_string_literal: true

module Github
  # Class representing a Github Issue
  class Issue
    attr_accessor :id, :repo, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @github = Octokit.issue("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def comments
      Octokit.issue_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.all(repo, page_number = 1)
      Octokit.list_issues("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })
    end
  end
end
