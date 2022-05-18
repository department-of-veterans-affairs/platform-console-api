# frozen_string_literal: true

class UserSerializer < BaseSerializer
  attributes :name, :email, :created_at, :updated_at
  has_many :teams

  link :self do |user|
    "#{ENV['BASE_URL']}/api/v1/users/#{user.id}"
  end
end
