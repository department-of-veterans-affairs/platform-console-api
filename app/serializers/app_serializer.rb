# frozen_string_literal: true

class AppSerializer < BaseSerializer
  attributes :name, :github_repo, :deploy_workflow, :created_at, :updated_at
  belongs_to :team
  has_many :deployments
end
