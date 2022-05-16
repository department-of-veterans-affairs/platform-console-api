# frozen_string_literal: true

module Github
  class WorkflowSerializer < ::BaseSerializer
    attributes :id, :node_id, :name, :path, :state, :created_at, :updated_at, :url, :html_url, :badge_url
    has_many :workflow_runs
  end
end
