# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @git_hub_workflow = git_hub_workflows(:one)
    end

    test 'should get index' do
      get git_hub_workflows_url
      assert_response :success
    end

    test 'should get new' do
      get new_git_hub_workflow_url
      assert_response :success
    end

    test 'should create git_hub_workflow' do
      assert_difference('GitHub::Workflow.count') do
        post git_hub_workflows_url, params: { git_hub_workflow: {} }
      end

      assert_redirected_to git_hub_workflow_url(GitHub::Workflow.last)
    end

    test 'should show git_hub_workflow' do
      get git_hub_workflow_url(@git_hub_workflow)
      assert_response :success
    end

    test 'should get edit' do
      get edit_git_hub_workflow_url(@git_hub_workflow)
      assert_response :success
    end

    test 'should update git_hub_workflow' do
      patch git_hub_workflow_url(@git_hub_workflow), params: { git_hub_workflow: {} }
      assert_redirected_to git_hub_workflow_url(@git_hub_workflow)
    end

    test 'should destroy git_hub_workflow' do
      assert_difference('GitHub::Workflow.count', -1) do
        delete git_hub_workflow_url(@git_hub_workflow)
      end

      assert_redirected_to git_hub_workflows_url
    end
  end
end
