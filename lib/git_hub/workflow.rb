# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Workflow
  class Workflow
    attr_accessor :gh_info, :repo

    def initialize(repo)
      @repo = repo
      @gh_info = Octokit.repository("#{GITHUB_ORGANIZATION}/#{@repo}")
    end

    def self.all(repo)
      Octokit.workflows("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def workflow_runs(workflow_id)
      GitHub::WorkflowRun.all_workflow(@repo, workflow_id)
    end
  end
end
