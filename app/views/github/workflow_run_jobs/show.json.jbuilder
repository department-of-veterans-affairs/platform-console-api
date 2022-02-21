# frozen_string_literal: true

json.partial! 'github/workflow_run_jobs/github_workflow_run_job', workflow_run_job: @github_workflow_run_job.github,
                                                                  workflow_run: @github_workflow_run.github
