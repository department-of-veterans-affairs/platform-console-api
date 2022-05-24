# frozen_string_literal: true

# Serializer for App model
class AppSerializer < BaseSerializer
  attributes :name, :github_repo, :deploy_workflow, :created_at, :updated_at

  belongs_to :team, links: {
    related: lambda { |object|
      "#{api_path}/teams/#{object.team_id}"
    }
  }

  has_many :deployments, links: {
    related: lambda { |object|
      "#{api_path}/teams/#{object.team_id}/apps/#{object.id}/deployments"
    }
  }

  link :self do |object|
    "#{api_path}/teams/#{object.team_id}/apps/#{object.id}"
  end
end
