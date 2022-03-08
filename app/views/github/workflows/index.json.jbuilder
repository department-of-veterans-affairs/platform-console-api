# frozen_string_literal: true

json.workflows @github_workflows.map(&:to_h)
