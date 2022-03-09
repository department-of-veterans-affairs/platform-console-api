# frozen_string_literal: true

# Create Deployments for Apps with multiple envs
class CreateDeployments < ActiveRecord::Migration[7.0]
  def change
    create_table :deployments do |t|
      t.string :name
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
