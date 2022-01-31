# frozen_string_literal: true

# Added UID to Users and removed password
class AddOauthParametersToUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :users, :uid, :string }
    safety_assured { add_column :users, :provider, :string }
    safety_assured { remove_column :users, :password_digest, :string }
    safety_assured { remove_column :users, :perishable_token, :string }
  end
end
