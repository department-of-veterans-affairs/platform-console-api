# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true
end
