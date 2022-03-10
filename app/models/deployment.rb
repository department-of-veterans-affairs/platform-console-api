# frozen_string_literal: true

class Deployment < ApplicationRecord
  belongs_to :app
  has_paper_trail
  validates :name, presence: true
end
