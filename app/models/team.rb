# frozen_string_literal: true

# The Team Model
class Team < ApplicationRecord
  validates :name, presence: true

  after_save :build_member

  belongs_to :owner, polymorphic: true
  has_many :apps, dependent: :nullify
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :teams, -> { where(owner_type: 'Team') }, inverse_of: :owner, foreign_key: :owner_id, dependent: :destroy

  private

  def build_member
    return if owner_type == 'Team'

    members.find_or_create_by!(user: owner)
  end
end
