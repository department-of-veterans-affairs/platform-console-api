# frozen_string_literal: true

# The Team Policy
class TeamPolicy < ApplicationPolicy
  def permitted_attributes
    %i[
      name owner_type owner_id
    ]
  end
end
