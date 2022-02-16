# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowsTest < ApplicationSystemTestCase
    # setup do
    #   @github_workflow = github_workflows(:one)
    # end

    # test 'visiting the index' do
    #   visit github_workflows_url
    #   assert_selector 'h1', text: 'Workflows'
    # end

    # test 'should create workflow' do
    #   visit github_workflows_url
    #   click_on 'New workflow'

    #   click_on 'Create Workflow'

    #   assert_text 'Workflow was successfully created'
    #   click_on 'Back'
    # end

    # test 'should update Workflow' do
    #   visit github_workflow_url(@github_workflow)
    #   click_on 'Edit this workflow', match: :first

    #   click_on 'Update Workflow'

    #   assert_text 'Workflow was successfully updated'
    #   click_on 'Back'
    # end

    # test 'should destroy Workflow' do
    #   visit github_workflow_url(@github_workflow)
    #   click_on 'Destroy this workflow', match: :first

    #   assert_text 'Workflow was successfully destroyed'
    # end
  end
end
