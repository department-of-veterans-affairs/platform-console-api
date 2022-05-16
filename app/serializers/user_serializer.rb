# frozen_string_literal: true

class UserSerializer < BaseSerializer
  attributes :name, :email, :created_at, :updated_at
  has_many :teams
end
