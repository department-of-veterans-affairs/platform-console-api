# frozen_string_literal: true

# The Team Model
class Team < ApplicationRecord
  validates :name, presence: true
  belongs_to :memberable, polymorphic: true, optional: true
  belongs_to :owner, polymorphic: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, source: :memberable, source_type: 'User'
  has_many :teams, through: :memberships, source: :memberable, source_type: 'Team'
  has_many :apps, dependent: :nullify
end
