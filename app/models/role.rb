# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :users, through: :user_roles
  has_paper_trail
  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
