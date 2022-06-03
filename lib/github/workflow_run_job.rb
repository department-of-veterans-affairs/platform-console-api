# frozen_string_literal: true

require 'rouge'

module Github
  # Class representing a Github WorkflowRunJob
  class WorkflowRunJob
    include Github::Pagination
    include Github::Inspect
    include Github::Collection

    attr_accessor :access_token, :repo, :id, :app_id

    # Creates a Github::WorkflowRunJob object with the github response attached
    #
    # @param repo [String] A GitHub repository
    # @param id [Integer] The ID of the WorkflowRunJob
    #
    # @return [Github::WorkflowRunJob]
    # @see https://docs.github.com/en/rest/reference/actions#get-a-job-for-a-workflow-run
    def initialize(access_token, repo, id, app_id = nil)
      @access_token = access_token
      @repo = repo
      @id = id
      @app_id = app_id
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
      def all_for_workflow_run(access_token, repo, app_id, workflow_run_id, page = 1)
        octokit_client = Octokit::Client.new(access_token: access_token)
        response = octokit_client.workflow_run_jobs(repo, workflow_run_id, page: page)
        pages = page_numbers(octokit_client)

        transform_collection_response(response.jobs, pages, repo, app_id)
      end
      alias all_for_deploy_run all_for_workflow_run
    end

    def octokit_client
      @octokit_client ||= Octokit::Client.new(access_token: access_token)
    end

    def github
      @github ||= octokit_client.workflow_run_job(repo, id)
    end

    # Formats the logs associated to a workflow run job.
    # This will check if logs exist on the job, if not it will check if there
    # are any outpust on the check run. This usually happens when there is a job that
    # that displays information at the end of a run (eg. Coverage, Test Results, ets=c.)
    #
    # @return [String] The logs or the jobs output
    # @see https://docs.github.com/en/rest/reference/actions#download-job-logs-for-a-workflow-run
    # @see https://docs.github.com/en/rest/reference/checks#get-a-check-run
    def logs
      result = begin
        octokit_client.workflow_run_job_logs(repo, id)
      rescue Octokit::NotFound
        begin
          check_run = octokit_client.check_run_from_url(github.check_run_url)
          "#{check_run.output.title} \n #{check_run.output.summary}"
        rescue Octokit::NotFound
          ''
        end
      end
      @logs ||= logs_to_html(result)
    end

    def workflow_run_id
      github.run_id
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
