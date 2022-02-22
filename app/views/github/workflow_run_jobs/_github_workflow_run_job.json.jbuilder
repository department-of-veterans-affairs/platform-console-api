# frozen_string_literal: true

json.extract! workflow_run_job, :id, :url, :run_id, :status, :conclusion, :started_at, :completed_at, :labels,
              :runner_id, :runner_name, :runner_group_id, :runner_group_name, :steps
json.url team_app_github_repository_workflow_workflow_run_workflow_run_job_url(@team, @app, @app.github_repo,
                                                                               workflow_run[:workflow_id],
                                                                               workflow_run[:id],
                                                                               workflow_run_job[:id], format: :json)
