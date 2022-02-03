# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true
  belongs_to :memberable, polymorphic: true, optional: true
  belongs_to :owner, polymorphic: true
  has_many :memberships, as: :memberable, dependent: :destroy, class_name: 'Membership'
  has_many :users, through: :memberships, source: :memberable, source_type: 'User'
  has_many :teams, through: :memberships, source: :memberable, source_type: 'Team'
end
