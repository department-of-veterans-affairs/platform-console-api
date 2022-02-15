# frozen_string_literal: true

# The User Model
class User < ApplicationRecord
  has_paper_trail
  has_secure_password
  before_validation :downcase_email
  rolify
  validates :email, uniqueness: true
  validates :name, :email, presence: true
  validates :password, length: { minimum: 8 }, if: :password

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
