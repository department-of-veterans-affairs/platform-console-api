# frozen_string_literal: true

json.extract! workflow, :id, :name, :state, :path, :created_at, :updated_at
json.url team_app_github_repository_workflow_url(@team, @app, @app.github_repo, workflow[:id],
                                                 format: :json)
