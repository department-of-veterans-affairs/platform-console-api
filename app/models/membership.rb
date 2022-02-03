# frozen_string_literal: true

# The Membership Model
class Membership < ApplicationRecord
  has_secure_password
  belongs_to :memberable, polymorphic: true
end
