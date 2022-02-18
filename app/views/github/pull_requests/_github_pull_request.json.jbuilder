# frozen_string_literal: true

json.extract! github_pull_request, :id, :title, :number, :state, :body, :created_at, :updated_at
json.url team_app_github_repository_pull_request_url(@team, @app, @app.github_repo_slug, github_pull_request.number,
                                                     format: :json)
