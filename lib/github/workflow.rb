# frozen_string_literal: true

module Github
  # Class representing a Github Workflow
  class Workflow
    include Github::Pagination

    attr_accessor :id, :file_name, :repo, :octokit_client, :github

    def initialize(repo, id_or_filename)
      @id = id_or_filename if id_or_filename.is_a?(Integer)
      @file_name = id_or_filename if id_or_filename.is_a?(String)
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.workflow("#{GITHUB_ORGANIZATION}/#{@repo}", id_or_filename)
      @id ||= @github[:id]
      @file_name ||= @github[:path]&.split('/')&.last
    end

    def self.dispatch!(repo, workflow_id, ref, options = {})
      octokit_client = Octokit::Client.new
      octokit_client.workflow_dispatch("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, ref, options)
    end

    def self.all(repo)
      octokit_client = Octokit::Client.new
      octokit_client.workflows("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def workflow_runs(page = 1)
      Github::WorkflowRun.all_for_workflow(@repo, @id, page)
    end
  end
end
