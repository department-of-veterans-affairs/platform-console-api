# frozen_string_literal: true

module Github
  # Class representing a Github Workflow
  class Workflow
    include Github::Pagination

    attr_accessor :id, :file_name, :repo, :octokit_client, :github

    # Creates an Github::Workflow object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id_or_filename [Integer, String] The ID or fil name of the Workflow
    #
    # @return [Github::Workflow]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-workflow
    def initialize(repo, id_or_filename)
      @id = id_or_filename if id_or_filename.is_a?(Integer)
      @file_name = id_or_filename if id_or_filename.is_a?(String)
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.workflow("#{GITHUB_ORGANIZATION}/#{@repo}", id_or_filename)
      @id ||= @github[:id]
      @file_name ||= @github[:path]&.split('/')&.last
    end

    # Dispatch a new run from a Workflow
    #
    # @param repo [String] A GitHub repository
    # @param workflow_id [Integer] Page number
    # @param ref [String, Integer] ref to dispatch workflow on
    # @param options [Hash]
    #
    # @return [Boolean] If the dispatch was successful
    # @see https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event
    def self.dispatch!(repo, workflow_id, ref, options = {})
      octokit_client = Octokit::Client.new
      octokit_client.workflow_dispatch("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, ref, options)
    end

    # List all repository workflows
    #
    # @param repo [String] A GitHub repository
    #
    # @return [Sawyer::Resource] Workflows
    # @see https://docs.github.com/en/rest/reference/actions#list-repository-workflows
    def self.all(repo)
      octokit_client = Octokit::Client.new
      octokit_client.workflows("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    # List all Workflows Runs associated to a workflow in this repo
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflow Runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs
    def workflow_runs(page = 1)
      Github::WorkflowRun.all_for_workflow(@repo, @id, page)
    end
  end
end
