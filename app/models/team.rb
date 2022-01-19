# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
