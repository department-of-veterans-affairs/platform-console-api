# frozen_string_literal: true

# Serializer for User model
class UserSerializer < BaseSerializer
  attributes :name, :email, :created_at, :updated_at
  has_many :teams, links: {
    related: lambda { |object|
      "#{api_path}/users/#{object.id}/teams"
    }
  }

  link :self do |object|
    "#{api_path}/users/#{object.id}"
  end
end
