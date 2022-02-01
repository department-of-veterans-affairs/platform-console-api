# frozen_string_literal: true

# Replace perishable token with uid in prep for Omniauth
class RenamePerishableTokenToUidOnUser < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    safety_assured { rename_column :users, :perishable_token, :uid }
  end
end
