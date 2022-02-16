# frozen_string_literal: true

require 'rouge'

module Github
  # Class representing a Github WorkflowRun
  class WorkflowRunJob
    attr_accessor :id, :repo, :logs, :github

    def initialize(repo, id)
      @id = id
      @repo = repo
      @logs = format_logs
      @github = Octokit.workflow_run_job("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
    end

    def format_logs
      logs = begin
        Octokit.workflow_run_job_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        return nil
      end
      logs_to_html(logs)
    end

    def self.all_for_workflow_run(repo, workflow_run_id)
      Octokit.workflow_run_jobs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_run_id)
    end

    private

    def logs_to_html(logs)
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexers::Shell.new
      formatter.format(lexer.lex(logs))
    end
  end
end
