# frozen_string_literal: true

# The ApiKey Model
class ApiKey < ApplicationRecord
  belongs_to :bearer, polymorphic: true
  encrypts :token, deterministic: true

  def self.generate
    SecureRandom.hex
  end
end
