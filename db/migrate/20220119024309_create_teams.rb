# frozen_string_literal: true

# Teams which can be owned by a user or other teams
class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :owner, polymorphic: true, null: false

      t.timestamps
    end
  end
end
