# frozen_string_literal: true

require 'application_system_test_case'

module GitHub
  class WorkflowsTest < ApplicationSystemTestCase
    setup do
      @git_hub_workflow = git_hub_workflows(:one)
    end

    test 'visiting the index' do
      visit git_hub_workflows_url
      assert_selector 'h1', text: 'Workflows'
    end

    test 'should create workflow' do
      visit git_hub_workflows_url
      click_on 'New workflow'

      click_on 'Create Workflow'

      assert_text 'Workflow was successfully created'
      click_on 'Back'
    end

    test 'should update Workflow' do
      visit git_hub_workflow_url(@git_hub_workflow)
      click_on 'Edit this workflow', match: :first

      click_on 'Update Workflow'

      assert_text 'Workflow was successfully updated'
      click_on 'Back'
    end

    test 'should destroy Workflow' do
      visit git_hub_workflow_url(@git_hub_workflow)
      click_on 'Destroy this workflow', match: :first

      assert_text 'Workflow was successfully destroyed'
    end
  end
end
