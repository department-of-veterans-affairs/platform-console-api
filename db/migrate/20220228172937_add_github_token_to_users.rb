# frozen_string_literal: true

# Adds the GitHub Access Token to Users table
class AddGithubTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_token, :string
  end
end
