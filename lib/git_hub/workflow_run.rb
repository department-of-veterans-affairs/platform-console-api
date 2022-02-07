# frozen_string_literal: true

require 'zip'
require 'open-uri'

module GitHub
  # Class representing a GitHub WorkflowRun
  class WorkflowRun
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
      extract_logs(url)
    end

    def self.all(repo, workflow_id)
      Octokit.workflow_runs(repo_path(repo), workflow_id)
    end

    private

    # Extracts workflow run logs into a string.
    def extract_logs(url)
      logs_zip = URI.parse(url).open
      file = Zip::File.open(logs_zip)

      # Retreive latest two log file names
      file_names = file.entries.map { |entry| entry.name unless entry.name.include?('/') }
                       .compact
                       .sort
                       .last(2)

      log_contents = ''
      file_names.each do |name|
        log_contents += file.find_entry(name).get_input_stream.read
      end
      log_contents
    end
  end
end
