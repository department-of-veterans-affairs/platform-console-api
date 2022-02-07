# frozen_string_literal: true

require 'zip'
require 'open-uri'

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRun
    include GitHub
    attr_accessor :repo, :id, :gh_info

    def initialize(repo, id)
      @repo = repo
      @id = id
      @gh_info = Octokit.workflow_run(repo_path(repo), @id)
    end

    def rerun!
      Octokit.rerun_workflow_run(repo_path(@repo), @id)
    end

    def logs
      url = Octokit.workflow_run_logs(repo_path(@repo), @id)
      logs_zip = URI.parse(url).open
      extract_logs(logs_zip)
    end

    def self.all(repo, workflow_id)
      Octokit.workflow_runs(repo_path(repo), workflow_id)
    end

    private

    # Extracts workflow run logs into a string.
    def extract_logs(zip_file)
      file = Zip::File.open(zip_file)

      # Retreive the names of the latest two log file names since they seem to come in pairs.
      # Ex: 1_Analyze.txt and 1_Analyze (1).txt
      file_names = file.entries.map { |entry| entry.name unless entry.name.include?('/') }
                       .compact
                       .sort
                       .last(2)

      # Combine the entries of the two log files into a single string.
      log_contents = ''
      file_names.each do |name|
        log_contents += file.find_entry(name).get_input_stream.read
      end
      log_contents
    end
  end
end
