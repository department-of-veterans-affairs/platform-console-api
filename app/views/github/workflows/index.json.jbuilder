# frozen_string_literal: true

json.workflows @github_workflows[:workflows].map(&:to_h)
