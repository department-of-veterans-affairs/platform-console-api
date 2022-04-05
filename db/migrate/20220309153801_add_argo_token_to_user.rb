# frozen_string_literal: true

# Add argo token to users table
class AddArgoTokenToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :keycloak_token, :string
  end
end
