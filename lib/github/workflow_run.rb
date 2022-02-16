# frozen_string_literal: true

require 'zip'
require 'open-uri'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRun
    attr_accessor :id, :repo, :logs_url, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @logs_url = begin
        Octokit.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        nil
      end
      @github = Octokit.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def rerun!
      Octokit.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def jobs
      Github::WorkflowRunJob.all_for_workflow_run(@repo, @id)
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
