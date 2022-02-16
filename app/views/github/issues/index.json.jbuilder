# frozen_string_literal: true

json.array! @github_issues, partial: 'github_issues/github_issue', as: :github_issue
