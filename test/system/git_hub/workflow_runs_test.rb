# frozen_string_literal: true

require 'application_system_test_case'

module GitHub
  class WorkflowRunsTest < ApplicationSystemTestCase
    # setup do
    #   @git_hub_workflow_run = git_hub_workflow_runs(:one)
    # end

    # test 'visiting the index' do
    #   visit git_hub_workflow_runs_url
    #   assert_selector 'h1', text: 'Workflow runs'
    # end

    # test 'should create workflow run' do
    #   visit git_hub_workflow_runs_url
    #   click_on 'New workflow run'

    #   click_on 'Create Workflow run'

    #   assert_text 'Workflow run was successfully created'
    #   click_on 'Back'
    # end

    # test 'should update Workflow run' do
    #   visit git_hub_workflow_run_url(@git_hub_workflow_run)
    #   click_on 'Edit this workflow run', match: :first

    #   click_on 'Update Workflow run'

    #   assert_text 'Workflow run was successfully updated'
    #   click_on 'Back'
    # end

    # test 'should destroy Workflow run' do
    #   visit git_hub_workflow_run_url(@git_hub_workflow_run)
    #   click_on 'Destroy this workflow run', match: :first

    #   assert_text 'Workflow run was successfully destroyed'
    # end
  end
end
