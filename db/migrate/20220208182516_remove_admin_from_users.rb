# frozen_string_literal: true

# Admin checks moved to roles table (Rolify)
class RemoveAdminFromUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :users, :admin, :boolean }
  end
end
