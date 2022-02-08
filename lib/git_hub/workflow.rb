# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Workflow
  class Workflow
    include GitHub
    attr_accessor :gh_info, :repo, :workflow_id

    def initialize(repo, id)
      @repo = repo
      @workflow_id = id
      @gh_info = Octokit.repository(repo_path(repo))
    end

    def runs
      GitHub::WorkflowRun.all_for_workflow(@repo, @workflow_id)
    end

    def self.all(repo)
      Octokit.workflows(repo_path(repo))
    end
  end
end
