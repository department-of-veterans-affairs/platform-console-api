# frozen_string_literal: true

require 'zip'
require 'open-uri'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRun < Base
    attr_accessor :id, :repo, :octokit_client, :logs_url, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @logs_url = begin
        octokit_client.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        nil
      end
      @github = @octokit_client.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def rerun!
      @octokit_client.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def jobs
      Github::WorkflowRunJob.all_for_workflow_run(@repo, @id)
    end

    def self.all(repo, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", page: page)

      response[:pages] = page_links(octokit_client)
      response
    end

    def self.all_for_branch(repo, branch_name, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", branch: branch_name,
                                                                                           page: page)

      response[:pages] = page_links(octokit_client)
      response
    end

    def self.all_for_workflow(repo, workflow_id, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id, page: page)

      response[:pages] = page_links(octokit_client)
      response
    end
  end
end
