# frozen_string_literal: true

# The App Model
class App < ApplicationRecord
  belongs_to :team
  validates :name, presence: true

  GITHUB_ORGANIZATION = 'department-of-veterans-affairs'

  def self.github_repo_search(query)
    Octokit.search_repositories("#{GITHUB_ORGANIZATION}/#{query}")[:items].pluck(:name).first(15)
  end
end
