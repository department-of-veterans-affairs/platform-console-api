# frozen_string_literal: true

require 'argo_cd/client'

# The User Model
class User < ApplicationRecord
  has_paper_trail
  has_secure_password
  encrypts :github_token
  before_validation :downcase_email
  rolify
  validates :email, uniqueness: true
  validates :name, :email, presence: true

  def self.from_omniauth(auth_hash)
    User.find_or_initialize_by(uid: auth_hash['uid']) do |u|
      u.name = auth_hash['info']['name']
      u.email = auth_hash['info']['email']
      # Tokens have a short expiration date.
      # The token should be stored in the session or database for every login.
      u.password = SecureRandom.uuid
      u.save!
    end

    # Authorize user and ensure keycloak is the provider
    # teams = auth_hash['extra']['raw_info']['groups']
    # roles = auth_hash['extra']['raw_info']['resource_access']['account']['roles']
  end

  def github_user
    return nil if github_token.blank?

    begin
      Octokit::Client.new(access_token: github_token).user
    rescue Octokit::Unauthorized
      nil
    end
  end

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
