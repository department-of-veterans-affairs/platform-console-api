# frozen_string_literal: true

class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true
end
