# frozen_string_literal: true

json.extract! workflow_run, :id, :name, :head_branch, :run_number, :event, :status, :conclusion, :workflow_id,
              :created_at, :updated_at
json.url team_app_github_repository_workflow_workflow_run_url(@team, @app, @app.github_repo,
                                                              workflow_run[:workflow_id],
                                                              workflow_run[:id], format: :json)
json.workflow_url team_app_github_repository_workflow_url(@team, @app, @app.github_repo,
                                                          workflow_run[:workflow_id], format: :json)
