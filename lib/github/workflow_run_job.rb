# frozen_string_literal: true

require 'rouge'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRunJob
    include Github::Pagination

    attr_accessor :id, :repo, :octokit_client, :logs, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @octokit_client = Octokit::Client.new
      @github = octokit_client.workflow_run_job("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @logs = format_logs
    end

    def format_logs
      logs = begin
        @octokit_client.workflow_run_job_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        begin
          check_run = Octokit.check_run_from_url(github.check_run_url)
          "#{check_run.output.title} \n #{check_run.output.summary}"
        rescue Octokit::NotFound
          ''
        end
      end
      logs_to_html(logs)
    end

    def self.all_for_workflow_run(repo, workflow_run_id, page = 1)
      octokit_client = Octokit::Client.new
      response = octokit_client.workflow_run_jobs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_run_id, page: page)

      response[:pages] = page_numbers(octokit_client)
      response
    end

    private

    def logs_to_html(logs)
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexers::Shell.new
      formatter.format(lexer.lex(logs))
    end
  end
end
