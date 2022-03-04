# frozen_string_literal: true

# The User Model
class User < ApplicationRecord
  has_paper_trail
  has_secure_password
  before_validation :downcase_email
  rolify
  validates :email, uniqueness: true
  validates :name, :email, presence: true

  has_many :team_members, dependent: :destroy
  has_many :teams, through: :team_members

  def self.from_omniauth(auth_hash)
    user = User.find_or_initialize_by(uid: auth_hash['uid'])
    user.name = auth_hash['info']['name']
    user.email = auth_hash['info']['email']
    user.password = SecureRandom.uuid
    user.save!

    return user if auth_hash['extra'].blank? || auth_hash['extra']['raw_info'].blank?
    build_team_members(user, auth_hash['extra']['raw_info']['groups'])
    # roles = auth_hash['extra']['raw_info']['resource_access']['account']['roles']

    return user
  end

  def self.build_team_members(user, team_names)
    return if team_names.blank?
    team_names.each do |team_name|
      team = Team.find_or_initialize_by(name: team_name)
      if team.new_record?
        team.owner = user
        team.owner_type = "User"
        team.save!
      end
      team.team_members.find_or_create_by!(user: user)
    end
  end

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
