# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/workflow') do
        @deploy = Github::Deploy.new('vets-api', '13418388')
      end
    end

    test 'can be created with a valid repo and deploy id' do
      assert_instance_of Github::Deploy, @deploy
      assert_instance_of Sawyer::Resource, @deploy.github
      assert_equal 13_418_388, @deploy.github.id
    end

    test 'lists all runs for the deploy' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        deploy_runs = @deploy.deploy_runs.deploy_runs
        assert_equal 13_418_388, deploy_runs.first.deploy_id
      end
    end

    test 'lists all deploys for the given repository' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        deploys = Github::Deploy.all('vets-api').deploys
        assert_kind_of Array, deploys
        assert_not_nil deploys.first.state
      end
    end

    test 'dispatch a deploy' do
      VCR.use_cassette('github/workflow') do
        dispatch = Github::Deploy.dispatch!('platform-console', 17_929_736, 'master')
        assert dispatch
      end
    end
  end
end
