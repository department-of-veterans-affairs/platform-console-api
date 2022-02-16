# frozen_string_literal: true

json.array! @github_workflows, partial: 'github_workflows/github_workflow', as: :github_workflow
