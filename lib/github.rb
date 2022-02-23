# frozen_string_literal: true

require 'github/pagination'
require 'github/issue'
require 'github/pull_request'
require 'github/repository'
require 'github/workflow_run'
require 'github/workflow_run_job'
require 'github/workflow'
require 'github/deploy'
require 'github/deploy_run'
require 'github/deploy_run_job'

# Contains classes/methods for Github API integration
module Github
  GITHUB_ORGANIZATION = 'department-of-veterans-affairs'
  CREATE_PR_WORKFLOW_FILE = 'create_deploy_pr.yml'
  DEPLOY_WORKFLOW_FILE = 'deploy-template.yml'
end
