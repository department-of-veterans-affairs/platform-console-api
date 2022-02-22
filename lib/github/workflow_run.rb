# frozen_string_literal: true

require 'zip'
require 'open-uri'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRun
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :logs_url, :github

    # Creates an Github::WorkflowRun object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the WorkflowRun
    #
    # @return [Github::WorkflowRun]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-workflow-run
    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @logs_url = begin
        octokit_client.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        nil
      end
      @github = @octokit_client.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    # List all Workflow Runs associated to a Repository
    #
    # @param repo [String] A GitHub repository
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflow Runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
    def self.all(repo, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List all Workflows Runs associated to a branch in this repo
    #
    # @param repo [String] A GitHub repository
    # @param branch_name [String] Branch name
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflow Runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
    def self.all_for_branch(repo, branch_name, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", branch: branch_name,
                                                                                           page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List all Workflows Runs associated to a workflow in this repo
    #
    # @param repo [String] A GitHub repository
    # @param workflow_id [Integer] ID of Workflow
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflow Runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs
    def self.all_for_workflow(repo, workflow_id, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    # List all Workflows Run Jobs associated to a Workflow Run
    #
    # @return [Sawyer::Resource] Workflows Run Jobs
    # @see https://docs.github.com/en/rest/reference/actions#re-run-a-workflow
    def jobs
      Github::WorkflowRunJob.all_for_workflow_run(@repo, @id)
    end

    # Rerun a Workflow Run
    #
    # @return [Boolean] If the rerun was successful
    # @see https://docs.github.com/en/rest/reference/actions#re-run-a-workflow
    def rerun!
      @octokit_client.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end
  end
end
