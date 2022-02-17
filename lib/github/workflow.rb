# frozen_string_literal: true

module Github
  # Class representing a Github Workflow
  class Workflow
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.workflow("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.dispatch!(repo, workflow_id, ref)
      octokit_client = Octokit::Client.new
      octokit_client.workflow_dispatch("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, ref)
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
