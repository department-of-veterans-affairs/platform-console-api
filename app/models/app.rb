# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true

  def git_hub_repository
    GitHub::Repository.new(github_repo_slug)
  end
end
