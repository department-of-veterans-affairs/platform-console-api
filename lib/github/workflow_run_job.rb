# frozen_string_literal: true

require 'rouge'

module Github
  # Class representing a Github WorkflowRunJob
  class WorkflowRunJob
    include Github::Pagination

    attr_accessor :access_token, :repo, :id, :octokit_client, :logs, :github

    # Creates a Github::WorkflowRunJob object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the WorkflowRunJob
    #
    # @return [Github::WorkflowRunJob]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-job-for-a-workflow-run
    def initialize(access_token, repo, id)
      @access_token = access_token
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new(access_token: @access_token)
      @github = octokit_client.workflow_run_job(@repo, @id)
      @logs = format_logs
    end

    class << self
      # List all Workflow Run Jobs associated to a Workflow Run
      #
      # @param repo [String] A GitHub repository
      # @param workflow_run_id [Integer] A GitHub repository
      # @param page [Integer] Page number
      #
      # @return [Sawyer::Resource] Issues
      # @see https://docs.github.com/en/rest/reference/issues#list-repository-issues
      def all_for_workflow_run(access_token, repo, workflow_run_id, page = 1)
        octokit_client = Octokit::Client.new(access_token: access_token)
        response = octokit_client.workflow_run_jobs(repo, workflow_run_id, page: page)

        response[:pages] = page_numbers(octokit_client)
        response
      end
      alias all_for_deploy_run all_for_workflow_run
    end

    # Formats the logs associated to a workflow run job.
    # This will check if logs exist on the job, if not it will check if there
    # are any outpust on the check run. This usually happens when there is a job that
    # that displays information at the end of a run (eg. Coverage, Test Results, ets=c.)
    #
    # @return [String] The logs or the jobs output
    # @see https://docs.github.com/en/rest/reference/actions#download-job-logs-for-a-workflow-run
    # @see https://docs.github.com/en/rest/reference/checks#get-a-check-run
    def format_logs
      logs = begin
        @octokit_client.workflow_run_job_logs(@repo, @id)
      rescue Octokit::NotFound
        begin
          check_run = @octokit_client.check_run_from_url(github.check_run_url)
          "#{check_run.output.title} \n #{check_run.output.summary}"
        rescue Octokit::NotFound
          ''
        end
      end
      logs_to_html(logs)
    end

    private

    # Formats the logs to HTML to make them look pretty
    #
    # @return [String] HTML escaped logs
    def logs_to_html(logs)
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexers::Shell.new
      formatter.format(lexer.lex(logs))
    end
  end
end
