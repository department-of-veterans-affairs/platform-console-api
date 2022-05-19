# frozen_string_literal: true

# Serializer for App model
class AppSerializer < BaseSerializer
  attributes :name, :github_repo, :deploy_workflow, :created_at, :updated_at

  belongs_to :team, links: {
    related: lambda { |app|
      "#{ENV['BASE_URL']}/api/v1/teams/#{app.team_id}"
    }
  }

  has_many :deployments, links: {
    related: lambda { |app|
      "#{ENV['BASE_URL']}/api/v1/teams/#{app.team_id}/apps/#{app.id}/deployments"
    }
  }

  link :self do |app|
    "#{ENV['BASE_URL']}/api/v1/teams/#{app.team_id}/apps/#{app.id}"
  end
end
