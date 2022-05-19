# frozen_string_literal: true

# Serializer for User model
class UserSerializer < BaseSerializer
  attributes :name, :email, :created_at, :updated_at
  has_many :teams, links: {
    related: lambda { |user|
      "#{ENV['BASE_URL']}/api/v1/users/#{user.id}/teams"
    }
  }

  link :self do |user|
    "#{ENV['BASE_URL']}/api/v1/users/#{user.id}"
  end
end
