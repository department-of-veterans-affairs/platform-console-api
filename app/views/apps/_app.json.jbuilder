# frozen_string_literal: true

json.extract! app, :id, :name, :team_id, :created_at, :updated_at
json.url team_app_url(@team, app, format: :json)
