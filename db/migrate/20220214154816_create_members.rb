# frozen_string_literal: true

# Create team members
class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.references :team, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
