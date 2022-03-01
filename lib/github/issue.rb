# frozen_string_literal: true

module Github
  # Class representing a Github Issue
  class Issue
    include Github::Pagination

    attr_accessor :access_token, :repo, :id, :octokit_client, :github

    # Creates a Github::Issue object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the Issue
    #
    # @return [Github::Issue]
    # @see https://docs.github.com/en/rest/reference/issues#get-an-issue
    def initialize(access_token, repo, id)
      @access_token = access_token
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new(access_token: @access_token)
      @github = octokit_client.issue(@repo, @id)
    end

    # List all Issues associated with a repository
    #
    # @param repo [String] A GitHub repository
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Issues
    # @see https://docs.github.com/en/rest/reference/issues#list-repository-issues
    def self.all(access_token, repo, page_number = 1)
      octokit_client = Octokit::Client.new(access_token: access_token)
      response = {}
      response[:issues] = octokit_client.list_issues(repo, { page: page_number })

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List an Issue's comments
    #
    # @return [Sawyer::Resource] Comments
    # @see https://docs.github.com/en/rest/reference/issues#list-issue-comments
    def comments
      @octokit_client.issue_comments(@repo, @id)
    end
  end
end
