# frozen_string_literal: true

json.extract! repository, :id, :name, :full_name, :description, :open_issues_count, :private, :archived, :disabled,
              :visibility, :fork, :forks_count, :watchers_count, :created_at, :updated_at
json.url team_app_github_repository_url(@team, @app, @app.github_repo, format: :json)
