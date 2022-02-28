# frozen_string_literal: true

module Github
  # Class representing a Github Deploy
  class Deploy < Workflow
    def initialize(access_token, repo)
      super(access_token, repo, DEPLOY_WORKFLOW_FILE)
    end
  end
end
