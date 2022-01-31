# frozen_string_literal: true

# Allows for querying if user is an admin via User.last.admin?
class AddAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean
  end
end
