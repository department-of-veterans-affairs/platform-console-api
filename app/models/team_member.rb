# frozen_string_literal: true

# The Team Member Model
class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
