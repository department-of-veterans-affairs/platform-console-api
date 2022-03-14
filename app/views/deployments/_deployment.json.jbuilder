# frozen_string_literal: true

json.extract! deployment, :id, :app_id, :name, :created_at, :updated_at
json.url deployment_url(deployment, format: :json)
