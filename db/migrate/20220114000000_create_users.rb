# frozen_string_literal: true

# The start of the users table
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, index: { unique: true }
      t.string :password_digest, index: true
      t.string :perishable_token, index: true

      t.timestamps
    end
  end
end
