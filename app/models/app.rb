# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true
  before_save :validate_github_repo, if: :will_save_change_to_github_repo_slug?

  def github_repository
    Github::Repository.new(github_repo_slug)
  end

  private

  def validate_github_repo
    return if github_repo_slug.blank?

    begin
      Github::Repository.new(github_repo_slug)
    rescue Octokit::NotFound => e
      errors.add(:base, e.message)
      throw(:abort)
    end
  end
end
