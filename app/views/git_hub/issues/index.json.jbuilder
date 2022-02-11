# frozen_string_literal: true

json.array! @git_hub_issues, partial: 'git_hub_issues/git_hub_issue', as: :git_hub_issue
