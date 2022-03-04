class CreateTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_members do |t|
      t.references :user, null: false, on_delete: :cascade
      t.references :team, null: false, on_delete: :cascade

      t.timestamps
    end
  end
end
