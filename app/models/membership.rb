# frozen_string_literal: true

# The Membership Model
class Membership < ApplicationRecord
  belongs_to :team
  belongs_to :memberable, polymorphic: true
end
