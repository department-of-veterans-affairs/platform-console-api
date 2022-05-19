# frozen_string_literal: true

# Serializer for Team model
class TeamSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at

  belongs_to :owner, polymorphic: { User => :user }, links: {
    related: lambda { |team|
      "#{ENV['BASE_URL']}/api/v1/#{team.owner_type.downcase.pluralize}/#{team.owner_id}"
    }
  }
  has_many :apps, links: {
    related: lambda { |team|
      "#{ENV['BASE_URL']}/api/v1/teams/#{team.id}/apps"
    }
  }

  link :self do |team|
    "#{ENV['BASE_URL']}/api/v1/teams/#{team.id}"
  end
end
