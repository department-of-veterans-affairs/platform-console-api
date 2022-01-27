class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
