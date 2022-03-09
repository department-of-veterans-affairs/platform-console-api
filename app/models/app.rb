# frozen_string_literal: true

class App < ApplicationRecord
  belongs_to :team
  has_many :deployments, dependent: :destroy
  has_paper_trail
  validates :name, presence: true
end
