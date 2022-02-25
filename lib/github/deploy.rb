# frozen_string_literal: true

module Github
  # Class representing a Github Deploy
  class Deploy < Workflow
    def initialize(repo)
      super(repo, DEPLOY_WORKFLOW_FILE)
    end
  end
end
