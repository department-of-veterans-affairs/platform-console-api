# frozen_string_literal: true

require 'rouge'

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRunJob
    attr_accessor :repo, :id, :gh_info, :logs

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.workflow_run_job("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      @logs = format_logs
    end

    def format_logs
      logs = begin
        Octokit.workflow_run_job_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @id)
      rescue Octokit::NotFound
        begin
          check_run = Octokit.check_run_from_url(gh_info.check_run_url)
          "#{check_run.output.title} \n #{check_run.output.summary}"
        rescue Octokit::NotFound
          ''
        end
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
