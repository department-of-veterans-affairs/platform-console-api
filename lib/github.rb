# frozen_string_literal: true

require 'github/pagination'
require 'github/inspect'
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
  DEPLOY_WORKFLOW_FILE = 'deploy-template_demo.yml'
  GITHUB_OAUTH_URL = "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}
                                                               &redirect_uri=#{ENV['GITHUB_REDIRECT_URI']}
                                                               &scope=repo".squish.delete(' ')
end
