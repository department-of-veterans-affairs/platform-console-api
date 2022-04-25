# frozen_string_literal: true

# Add github repo slug to apps
class AddGithubRepoSlugToApps < ActiveRecord::Migration[7.0]
  def change
    add_column :apps, :github_repo, :string
  end
end
