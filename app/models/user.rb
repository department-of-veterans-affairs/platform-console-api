# frozen_string_literal: true

require 'argo_cd/client'

# The User Model
class User < ApplicationRecord
  encrypts :argo_token
  has_paper_trail
  has_secure_password
  before_validation :downcase_email
  rolify
  validates :email, uniqueness: true
  validates :name, :email, presence: true
  # before_destroy :revoke_argo_token

  def self.from_omniauth(auth_hash)
    User.find_or_initialize_by(uid: auth_hash['uid']) do |u|
      u.name = auth_hash['info']['name']
      u.email = auth_hash['info']['email']
      u.argo_token = auth_hash['credentials']['token']
      u.password = SecureRandom.uuid
      u.save!
    end
    # TODO: When will the token expire? Should we resave the token
    # on each sign in.

    # Authorize user and ensure keycloak is the provider
    # teams = auth_hash['extra']['raw_info']['groups']
    # roles = auth_hash['extra']['raw_info']['resource_access']['account']['roles']
  end

  def argo_token_invalid?
    begin
      decoded_token = JWT.decode(argo_token, nil, false)
    rescue StandardError
      return true
    end

    decoded_token_info = decoded_token[0]

    if decoded_token_info.keys.include?('exp')
      expiration = Time.zone.at(decoded_token_info['exp'])
      (expiration + 24.hours) <= DateTime.now # token has expired
    else
      false
    end
  end

  # def revoke_argo_token
  #   argo_client = ArgoCd::Client.new(nil, nil, id)
  #   @response = argo_client.destroy_token
  # end

  def token_id
    return if argo_token.nil?

    decoded_token = JWT.decode(argo_token, nil, false)
    decoded_token_info = decoded_token[0]
    decoded_token_info['jti']
  end

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
