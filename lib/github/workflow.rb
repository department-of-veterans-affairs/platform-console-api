# frozen_string_literal: true

module Github
  # Class representing a Github Workflow
  class Workflow
    attr_accessor :id, :repo, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @github = Octokit.workflow("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.dispatch!(repo, workflow_id, ref)
      Octokit.workflow_dispatch("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, ref)
    end

    def self.all(repo)
      Octokit.workflows("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def workflow_runs
      Github::WorkflowRun.all_for_workflow(@repo, @id)
    end
  end
end
