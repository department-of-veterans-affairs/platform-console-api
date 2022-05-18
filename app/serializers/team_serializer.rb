# frozen_string_literal: true

class TeamSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at
  belongs_to :owner, polymorphic: { User => :user }
  has_many :apps

  link :self do |team|
    "#{ENV['BASE_URL']}/api/v1/teams/#{team.id}"
  end
end
