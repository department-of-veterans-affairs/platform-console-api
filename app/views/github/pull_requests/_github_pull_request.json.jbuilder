# frozen_string_literal: true

json.extract! pull_request, :id, :title, :number, :state, :draft, :locked, :body, :created_at, :updated_at,
              :closed_at, :merged_at, :merge_commit_sha
json.url team_app_pull_requests_url(@team, @app, @app.github_repo, pull_request.number,
                                    format: :json)
