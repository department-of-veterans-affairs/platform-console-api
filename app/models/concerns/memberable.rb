# frozen_string_literal: true

module Memberable
  extend ActiveSupport::Concern
  included do
    has_many :memberships, as: :memberable, dependent: :destroy
  end
end
