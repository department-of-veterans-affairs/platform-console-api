# frozen_string_literal: true

# Serializer for Deployment model
class DeploymentSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at

  belongs_to :app, links: {
    related: lambda { |deployment|
      "#{ENV['BASE_URL']}/api/v1/teams/#{deployment.app.team_id}/apps/#{deployment.app.id}"
    }
  }

  link :self do |deployment|
    "#{ENV['BASE_URL']}/api/v1/teams/#{deployment.app.team.id}/apps/#{deployment.app.id}/deployments/#{deployment.id}"
  end
end
