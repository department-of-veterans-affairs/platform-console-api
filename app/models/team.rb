# frozen_string_literal: true

# The Team Model
class Team < ApplicationRecord
  validates :name, presence: true

  belongs_to :owner, polymorphic: true
  has_many :apps, dependent: :nullify
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  has_many :teams, -> { where(owner_type: 'Team') }, inverse_of: :owner, foreign_key: :owner_id, dependent: :destroy

  private

end
