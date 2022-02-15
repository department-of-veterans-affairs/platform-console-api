# frozen_string_literal: true

require 'zip'
require 'open-uri'

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRun
    attr_accessor :repo, :id, :gh_info, :logs_url

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @logs_url = begin
        Octokit.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        nil
      end
    end

    def rerun!
      Octokit.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def jobs
      GitHub::WorkflowRunJob.all_for_workflow_run(@repo, @id)
    end

    def self.all(repo)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def self.all_for_branch(repo, branch_name)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", branch: branch_name)
    end

    def self.all_for_workflow(repo, workflow_id)
      Octokit.workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id)
    end
  end
end
