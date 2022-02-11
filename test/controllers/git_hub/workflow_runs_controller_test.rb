# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
    # setup do
    #   @git_hub_workflow_run = git_hub_workflow_runs(:one)
    # end

    # test 'should get index' do
    #   get git_hub_workflow_runs_url
    #   assert_response :success
    # end

    # test 'should get new' do
    #   get new_git_hub_workflow_run_url
    #   assert_response :success
    # end

    # test 'should create git_hub_workflow_run' do
    #   assert_difference('GitHub::WorkflowRun.count') do
    #     post git_hub_workflow_runs_url, params: { git_hub_workflow_run: {} }
    #   end

    #   assert_redirected_to git_hub_workflow_run_url(GitHub::WorkflowRun.last)
    # end

    # test 'should show git_hub_workflow_run' do
    #   get git_hub_workflow_run_url(@git_hub_workflow_run)
    #   assert_response :success
    # end

    # test 'should get edit' do
    #   get edit_git_hub_workflow_run_url(@git_hub_workflow_run)
    #   assert_response :success
    # end

    # test 'should update git_hub_workflow_run' do
    #   patch git_hub_workflow_run_url(@git_hub_workflow_run), params: { git_hub_workflow_run: {} }
    #   assert_redirected_to git_hub_workflow_run_url(@git_hub_workflow_run)
    # end

    # test 'should destroy git_hub_workflow_run' do
    #   assert_difference('GitHub::WorkflowRun.count', -1) do
    #     delete git_hub_workflow_run_url(@git_hub_workflow_run)
    #   end

    #   assert_redirected_to git_hub_workflow_runs_url
    # end
  end
end
