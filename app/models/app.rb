# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  attr_accessor :current_user

  belongs_to :team
  has_many :deployments, dependent: :destroy
  has_paper_trail
  validates :name, presence: true
  before_save :validate_github_repo, if: :will_save_change_to_github_repo?

  def github_repository(access_token)
    Github::Repository.new(access_token, github_repo)
  end
  alias repository github_repository

  private

  def validate_github_repo
    return if github_repo.blank?

    unless github_repo.match?(%r{\w+/\w+})
      errors.add(:base, :invalid,
                 message: 'Github Repository is invalid. The repository must include the full path.
                 Ex: department-of-veterans-affairs/vets-api')
      throw(:abort)
    end

    begin
      Github::Repository.new(current_user.github_token, github_repo)
    rescue Octokit::NotFound, Octokit::Unauthorized, Octokit::Forbidden => e
      errors.add(:base, e.message)
      throw(:abort)
    end
  end
end
