# frozen_string_literal: true

@github_workflows.present? ? (json.workflows @github_workflows.map(&:to_h)) : {}
