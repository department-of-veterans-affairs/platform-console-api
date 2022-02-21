# frozen_string_literal: true

require 'github/pagination'
require 'github/issue'
require 'github/pull_request'
require 'github/repository'
require 'github/workflow_run'
require 'github/workflow_run_job'
require 'github/workflow'

# Contains classes/methods for Github API integration
module Github
  GITHUB_ORGANIZATION = 'department-of-veterans-affairs'
  CREATE_PR_WORKFLOW_FILE = 'create_deploy_pr.yml'
  DEPLOY_WORKFLOW_FILE = 'deploy-template_test.yml'
end
