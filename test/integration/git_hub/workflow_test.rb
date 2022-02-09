# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowTest < ActionDispatch::IntegrationTest
    test 'can be created with a valid repo and workflow id' do
      VCR.use_cassette('git_hub/workflow') do
        workflow = GitHub::Workflow.new('vets-api', '13418388')
        assert_instance_of GitHub::Workflow, workflow
        assert_instance_of Sawyer::Resource, workflow.gh_info
        assert_equal 13_418_388, workflow.gh_info.id
      end
    end
  end
end
