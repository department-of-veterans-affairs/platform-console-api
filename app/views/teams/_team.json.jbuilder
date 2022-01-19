# frozen_string_literal: true

json.extract! team, :id, :name, :owner_id, :owner_type, :created_at, :updated_at
json.url team_url(team, format: :json)
