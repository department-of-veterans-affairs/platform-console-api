# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :apps, dependent: :nullify
  has_paper_trail
  validates :name, presence: true
end
