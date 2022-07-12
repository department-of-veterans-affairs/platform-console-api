# frozen_string_literal: true

require 'zip'
require 'open-uri'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRun
    include Github::Pagination
    include Github::Inspect
    include Github::Collection

    attr_accessor :access_token, :repo, :id, :app_id

    # Creates a Github::WorkflowRun object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the WorkflowRun
    #
    # @return [Github::WorkflowRun]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-workflow-run
    def initialize(access_token, repo, id, app_id = nil)
      @access_token = access_token
      @repo = repo
      @id = id
      @app_id = app_id
    end

    class << self
      # List all Workflows Runs associated to a workflow in this repo
      #
      # @param repo [String] A GitHub repository
      # @param workflow_id [Integer] ID of Workflow
      # @param page [Integer] Page number
      #
      # @return [Sawyer::Resource] Workflow Runs
      # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs
      def all_for_workflow(access_token, repo, app_id, workflow_id, page = 1, options = {})
        options[:page] = page
        octokit_client = Octokit::Client.new(access_token: access_token)
        response = octokit_client.workflow_runs(repo, workflow_id, options)
        pages = page_numbers(octokit_client)

        transform_collection_response(response.workflow_runs, pages, repo, app_id)
      end
      alias all_for_deploy all_for_workflow

      # List all Workflows Runs associated to a branch in this repo
      #
      # @param repo [String] A GitHub repository
      # @param branch_name [String] Branch name
      # @param page [Integer] Page number
      #
      # @return [Sawyer::Resource] Workflow Runs
      # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
      def all_for_branch(access_token, repo, app_id, branch_name, page = 1)
        octokit_client = Octokit::Client.new(access_token: access_token)
        response = octokit_client.repository_workflow_runs(repo, branch: branch_name, page: page)
        pages = page_numbers(octokit_client)

        transform_collection_response(response.workflow_runs, pages, repo, app_id)
      end

      # List all Workflow Runs associated to a Repository
      #
      # @param repo [String] A GitHub repository
      # @param page [Integer] Page number
      #
      # @return [Sawyer::Resource] Workflow Runs
      # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs-for-a-repository
      def all(access_token, repo, app_id, page = 1)
        octokit_client = Octokit::Client.new(access_token: access_token)
        response = octokit_client.repository_workflow_runs(repo, page: page)
        pages = page_numbers(octokit_client)

        transform_collection_response(response.workflow_runs, pages, repo, app_id)
      end
    end

    def octokit_client
      @octokit_client ||= Octokit::Client.new(access_token: access_token)
    end

    def github
      @github ||= octokit_client.workflow_run(repo, id)
    end

    def logs_url
      @logs_url ||= begin
        octokit_client.workflow_run_logs(repo, id)
      rescue Octokit::NotFound
        nil
      end
    end

    # List all Workflows Run Jobs associated to a Workflow Run
    #
    # @return [Sawyer::Resource] Workflows Run Jobs
    # @see https://docs.github.com/en/rest/reference/actions#re-run-a-workflow
    def jobs
      Github::WorkflowRunJob.all_for_workflow_run(access_token, repo, app_id, id)
    end

    def jobs_ids
      jobs[:objects].pluck(:id)
    end

    delegate :workflow_id, to: :github

    # Rerun a Workflow Run
    #
    # @return [Boolean] If the rerun was successful
    # @see https://docs.github.com/en/rest/reference/actions#re-run-a-workflow
    def rerun!
      octokit_client.rerun_workflow_run(repo, id)
    end
  end
end
