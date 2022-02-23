# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/deploy', record: :new_episodes) do
        Github::DEPLOY_WORKFLOW_FILE = 'codeql.yml'
        @deploy = Github::Deploy.new('platform-console-api')
      end
    end

    test 'can be created with a valid repo and deploy id' do
      assert_instance_of Github::Deploy, @deploy
      assert_instance_of Sawyer::Resource, @deploy.github
      assert_equal 17929736, @deploy.github.id
    end

    test 'lists all runs for the deploy' do
      VCR.use_cassette('github/deploy', record: :new_episodes) do
        deploy_runs = @deploy.deploy_runs.workflow_runs
        assert_equal 17929736, deploy_runs.first.workflow_id
      end
    end

    test 'dispatch a deploy' do
      VCR.use_cassette('github/deploy', record: :new_episodes) do
        dispatch = Github::Deploy.dispatch!('platform-console-api', Github::DEPLOY_WORKFLOW_FILE, 'master')
        assert dispatch
      end
    end
  end
end
