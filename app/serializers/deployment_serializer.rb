# frozen_string_literal: true

class DeploymentSerializer < BaseSerializer
  attributes :name, :created_at, :updated_at
  belongs_to :app
end
