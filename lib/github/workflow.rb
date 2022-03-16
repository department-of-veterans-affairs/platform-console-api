# frozen_string_literal: true

module Github
  # Class representing a Github Workflow
  class Workflow
    include Github::Pagination
    include Github::Inspect

    attr_accessor :access_token, :repo, :id, :file_name, :octokit_client, :inputs, :github

    # Creates a Github::Workflow object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id_or_filename [Integer, String] The ID or fil name of the Workflow
    #
    # @return [Github::Workflow]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-workflow
    def initialize(acccess_token, repo, id_or_filename)
      @access_token = acccess_token
      @repo = repo
      @id = id_or_filename if id_or_filename.is_a?(Integer)
      @file_name = id_or_filename if id_or_filename.is_a?(String)
      @octokit_client = Octokit::Client.new(access_token: @access_token)
      @github = octokit_client.workflow(@repo, id_or_filename)
      @id ||= @github[:id]
      @file_name ||= @github[:path]&.split('/')&.last
      @inputs = build_inputs
    end

    class << self
      # Dispatch a new run from a Workflow
      #
      # @param repo [String] A GitHub repository
      # @param workflow_id [Integer] Page number
      # @param ref [String, Integer] ref to dispatch workflow on
      # @param options [Hash]
      #
      # @return [Boolean] If the dispatch was successful
      # @see https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event
      def dispatch!(access_token, repo, workflow_id, ref, options = {})
        octokit_client = Octokit::Client.new(access_token: access_token)
        octokit_client.workflow_dispatch(repo, workflow_id, ref, options)
      end

      # List all repository workflows
      #
      # @param repo [String] A GitHub repository
      #
      # @return [Sawyer::Resource] Workflows
      # @see https://docs.github.com/en/rest/reference/actions#list-repository-workflows
      def all(access_token, repo)
        octokit_client = Octokit::Client.new(access_token: access_token)
        octokit_client.workflows(repo)
      end
    end

    # List all Workflows Runs associated to a workflow in this repo
    #
    # @param page [Integer] Page number
    #
    # @return [Sawyer::Resource] Workflow Runs
    # @see https://docs.github.com/en/rest/reference/actions#list-workflow-runs
    def workflow_runs(page = 1, options = {})
      Github::WorkflowRun.all_for_workflow(@access_token, @repo, @id, page, options)
    end
    alias deploy_runs workflow_runs

    # List the content of a file
    #
    # @return [String] the contents of the file
    # @see https://docs.github.com/en/rest/reference/repos#get-repository-content
    def content
      response = @octokit_client.contents(@repo, path: @github.path)
      Base64.decode64(response.content)
    end

    # Returns a list of the inputs for a workflow
    #
    # @return [Hash] the inputs for a workflow
    def build_inputs
      yml = YAML.safe_load(content).deep_symbolize_keys
      search_hash(yml, :inputs)
    end

    private

    def search_hash(hash, value)
      return hash[value] if hash.fetch(value, false)

      hash.each_key do |key|
        result = search_hash(hash[key], value) if hash[key].is_a? Hash
        return result if result
      end
      {}
    end
  end
end
