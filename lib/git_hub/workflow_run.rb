# frozen_string_literal: true

require 'zip'
require 'open-uri'

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRun
    attr_accessor :repo, :workflow_run_id, :gh_info

    def initialize(repo, workflow_run_id)
      @repo = repo
      @workflow_run_id = workflow_run_id
      @gh_info = Octokit.workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @workflow_run_id)
    end

    def rerun!
      Octokit.rerun_workflow_run("#{GITHUB_ORGANIZATION}/#{@repo}", @workflow_run_id)
    end

    def logs
      url = Octokit.workflow_run_logs("#{GITHUB_ORGANIZATION}/#{@repo}", @workflow_run_id)
      logs_zip = URI.parse(url).open
      extract_logs(logs_zip)
    end

    def self.all(repo)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}")
    end

    def self.all_for_branch(repo, branch)
      Octokit.repository_workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", branch:)
    end

    def self.all_for_workflow(repo, workflow_id)
      Octokit.workflow_runs("#{GITHUB_ORGANIZATION}/#{repo}", workflow_id)
    end

    private

    # Extracts workflow run logs into a hash.
    def extract_logs(zip_file) # rubocop:disable Metrics/AbcSize
      folder = Zip::File.open(zip_file)
      log_files = folder.entries.map { |entry| entry.name if entry.name.include?('/') && !entry.directory? }
                        .compact.sort_by { |name| name[/\d+/].to_i }

      results = {}
      log_files.each do |name|
        folder_name = name.split('/').first
        contents = folder.find_entry(name).get_input_stream.read
        results[folder_name] = results[folder_name].to_s + contents
      end

      results
    end
  end
end
