# frozen_string_literal: true

# Add keycloak access token to users table
class AddKeycloakAccessTokenToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :keycloak_access_token, :string
  end
end
