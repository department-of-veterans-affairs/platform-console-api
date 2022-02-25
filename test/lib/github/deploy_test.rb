# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/deploy', record: :new_episodes) do
        Github.send :remove_const, 'DEPLOY_WORKFLOW_FILE'
        Github.const_set 'DEPLOY_WORKFLOW_FILE', 'codeql.yml'
        @deploy = Github::Deploy.new('department-of-veterans-affairs/platform-console-api')
      end
    end

    test 'can be created with a valid repo' do
      assert_instance_of Github::Deploy, @deploy
      assert_instance_of Sawyer::Resource, @deploy.github
      assert_equal 17_929_736, @deploy.github.id
    end
  end
end
