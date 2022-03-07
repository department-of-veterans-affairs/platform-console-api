# frozen_string_literal: true

# Create Connected Apps to store/cache jwts/tokens
class CreateConnectedApps < ActiveRecord::Migration[7.0]
  def change
    create_table :connected_apps do |t|
      t.integer :user_id
      t.integer :app_id
      t.string :token

      t.timestamps
    end
  end
end
