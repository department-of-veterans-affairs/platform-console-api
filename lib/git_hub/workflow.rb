# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Workflow
  class Workflow
    include GitHub
    extend GitHub
    attr_accessor :gh_info, :repo, :workflow_id

    def initialize(repo, id)
      @repo = repo
      @workflow_id = id
      @gh_info = Octokit.workflow(repo_path(repo), id)
    end

    def runs
      GitHub::WorkflowRun.all_for_workflow(@repo, @workflow_id)
    end

    def self.all(repo)
      Octokit.workflows(repo_path(repo))
    end
  end
end
