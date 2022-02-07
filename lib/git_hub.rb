# frozen_string_literal: true

# Contains classes/methods for Github API integration
module GitHub
  GITHUB_ORGANIZATION = 'department-of-veterans-affairs'

  # Build the full path for a repository including the organization.
  def repo_path(repository)
    "#{GITHUB_ORGANIZATION}/#{repository}"
  end
end
