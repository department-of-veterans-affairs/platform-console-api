# frozen_string_literal: true

json.array! @github_workflows[:workflows], partial: 'github/workflows/github_workflow', as: :workflow
