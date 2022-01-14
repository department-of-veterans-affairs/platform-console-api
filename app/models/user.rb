# frozen_string_literal: true

# The User Model
class User < ApplicationRecord
  has_secure_password

  before_save :reset_perishable_token

  before_validation :downcase_email
  validates :email, uniqueness: true
  validates :name, :email, presence: true
  validates :password, length: { minimum: 8 }, if: :password

  private

  def downcase_email
    self.email = email.downcase if email?
  end

  def reset_perishable_token
    self.perishable_token = SecureRandom.uuid
  end
end
