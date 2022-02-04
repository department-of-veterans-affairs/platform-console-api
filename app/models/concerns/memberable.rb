# frozen_string_literal: true

# Memberships for Teams and Users
module Memberable
  extend ActiveSupport::Concern
  included do
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :teams, through: :memberships
  end
end
