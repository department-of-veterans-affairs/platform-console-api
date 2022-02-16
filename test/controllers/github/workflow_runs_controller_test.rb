# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
    # setup do
    #   @github_workflow_run = github_workflow_runs(:one)
    # end

    # test 'should get index' do
    #   get github_workflow_runs_url
    #   assert_response :success
    # end

    # test 'should get new' do
    #   get new_github_workflow_run_url
    #   assert_response :success
    # end

    # test 'should create github_workflow_run' do
    #   assert_difference('Github::WorkflowRun.count') do
    #     post github_workflow_runs_url, params: { github_workflow_run: {} }
    #   end

    #   assert_redirected_to github_workflow_run_url(Github::WorkflowRun.last)
    # end

    # test 'should show github_workflow_run' do
    #   get github_workflow_run_url(@github_workflow_run)
    #   assert_response :success
    # end

    # test 'should get edit' do
    #   get edit_github_workflow_run_url(@github_workflow_run)
    #   assert_response :success
    # end

    # test 'should update github_workflow_run' do
    #   patch github_workflow_run_url(@github_workflow_run), params: { github_workflow_run: {} }
    #   assert_redirected_to github_workflow_run_url(@github_workflow_run)
    # end

    # test 'should destroy github_workflow_run' do
    #   assert_difference('Github::WorkflowRun.count', -1) do
    #     delete github_workflow_run_url(@github_workflow_run)
    #   end

    #   assert_redirected_to github_workflow_runs_url
    # end
  end
end
