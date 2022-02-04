# frozen_string_literal: true

# Create memberships to join teams and users
class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.references :memberable, polymorphic: true, null: false
      t.references :team, foreign_key: true, null: false

      t.timestamps
    end
  end
end
