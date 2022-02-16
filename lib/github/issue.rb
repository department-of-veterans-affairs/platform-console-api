# frozen_string_literal: true

module Github
  # Class representing a Github Issue
  class Issue < Base
    attr_accessor :id, :repo, :octokit_client, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.issue("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def comments
      @octokit_client.issue_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.all(repo, page_number = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.list_issues("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })

      response[:pages] = page_links(octokit_client)
      response
    end
  end
end
