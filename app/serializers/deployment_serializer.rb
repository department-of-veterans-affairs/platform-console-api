# frozen_string_literal: true

# Serializer for Deployment model
class DeploymentSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at

  belongs_to :app, links: {
    related: lambda { |object|
      "#{api_path}/teams/#{object.app.team_id}/apps/#{object.app.id}"
    }
  }

  link :self do |object|
    "#{api_path}/teams/#{object.app.team.id}/apps/#{object.app.id}/deployments/#{object.id}"
  end
end
