# frozen_string_literal: true

json.array! @git_hub_workflows, partial: 'git_hub_workflows/git_hub_workflow', as: :git_hub_workflow
