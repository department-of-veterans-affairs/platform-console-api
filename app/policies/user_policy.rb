# frozen_string_literal: true

# The User Policy
class UserPolicy < ApplicationPolicy
  def permitted_attributes
    %i[
      name email password_digest uid
    ]
  end
end
