# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Workflow
  class Workflow
    attr_accessor :gh_info, :repo, :id

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.workflow("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.dispatch!(repo, workflow, ref)
      Octokit.workflow_dispatch("#{GITHUB_ORGANIZATION}/#{repo}", workflow, ref)
    end

    def self.all(repo)
      Octokit.workflows("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def workflow_runs
      GitHub::WorkflowRun.all_for_workflow(@repo, @id)
    end
  end
end
