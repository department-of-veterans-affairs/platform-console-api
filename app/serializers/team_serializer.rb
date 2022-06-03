# frozen_string_literal: true

# Serializer for Team model
class TeamSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at

  belongs_to :owner, polymorphic: { User => :user }, links: {
    related: lambda { |object|
      "#{api_path}/#{object.owner_type.downcase.pluralize}/#{object.owner_id}"
    }
  }
  has_many :apps, links: {
    related: lambda { |object|
      "#{api_path}/teams/#{object.id}/apps"
    }
  }

  link :self do |object|
    "#{api_path}/teams/#{object.id}"
  end
end
