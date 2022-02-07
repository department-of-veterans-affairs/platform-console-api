# frozen_string_literal: true

module GitHub
  # Class representing a GitHub Workflow
  class Workflow
    attr_accessor :gh_info, :repo, :workflow_id

    def initialize(repo, id)
      @repo = repo
      @workflow_id = id
      @gh_info = Octokit.repository(repo_path(repo))
    end

    def runs
      Octokit.workflow_runs(repo_path(@repo), @workflow_id)
    end

    def self.all(repo)
      Octokit.workflows(repo_path(repo))
    end
  end
end
