# frozen_string_literal: true

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRun
    attr_accessor :repo, :id, :gh_info

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def self.all_branch(repo, branch_name)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", { branch: branch_name })
    end

    def self.all_workflow(repo, workflow_id)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id)
    end

    def rerun!
      Octokit.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def logs
      url = Octokit.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      extract_logs(url)
    end

    private

    def extract_logs(url); end
  end
end
