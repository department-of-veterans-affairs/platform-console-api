# frozen_string_literal: true

# Add deploy workflow column to apps to store the filename
class AddDeployWorkflowToApps < ActiveRecord::Migration[7.0]
  def change
    add_column :apps, :deploy_workflow, :string
  end
end
