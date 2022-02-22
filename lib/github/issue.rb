# frozen_string_literal: true

module Github
  # Class representing a Github Issue
  class Issue
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :github

    # Creates an Github::Issue object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID o
    #
    # @return [Github::Issue]
    # @see https://docs.github.com/en/rest/reference/issues#get-an-issue
    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.issue("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    # List all Issues associated with a repository
    #
    # @param repo [String] A GitHub repository
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Issues
    # @see https://docs.github.com/en/rest/reference/issues#list-repository-issues
    def self.all(repo, page_number = 1)
      octokit_client = Octokit::Client.new
      response = {}
      response[:issues] = octokit_client.list_issues("#{GITHUB_ORGANIZATION}/#{repo}", { page: page_number })

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List an Issue's comments
    #
    # @return [Sawyer::Resource] Comments
    # @see https://docs.github.com/en/rest/reference/issues#list-issue-comments
    def comments
      @octokit_client.issue_comments("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end
  end
end
