# frozen_string_literal: true

require 'test_helper'

module GitHub
  class PullRequestsControllerTest < ActionDispatch::IntegrationTest
    # setup do
    #   @git_hub_pull_request = git_hub_pull_requests(:one)
    # end

    # test 'should get index' do
    #   get git_hub_pull_requests_url
    #   assert_response :success
    # end

    # test 'should get new' do
    #   get new_git_hub_pull_request_url
    #   assert_response :success
    # end

    # test 'should create git_hub_pull_request' do
    #   assert_difference('GitHub::PullRequest.count') do
    #     post git_hub_pull_requests_url, params: { git_hub_pull_request: { show: @git_hub_pull_request.show } }
    #   end

    #   assert_redirected_to git_hub_pull_request_url(GitHub::PullRequest.last)
    # end

    # test 'should show git_hub_pull_request' do
    #   get git_hub_pull_request_url(@git_hub_pull_request)
    #   assert_response :success
    # end

    # test 'should get edit' do
    #   get edit_git_hub_pull_request_url(@git_hub_pull_request)
    #   assert_response :success
    # end

    # test 'should update git_hub_pull_request' do
    #   patch git_hub_pull_request_url(@git_hub_pull_request),
    #         params: { git_hub_pull_request: { show: @git_hub_pull_request.show } }
    #   assert_redirected_to git_hub_pull_request_url(@git_hub_pull_request)
    # end

    # test 'should destroy git_hub_pull_request' do
    #   assert_difference('GitHub::PullRequest.count', -1) do
    #     delete git_hub_pull_request_url(@git_hub_pull_request)
    #   end

    #   assert_redirected_to git_hub_pull_requests_url
    # end
  end
end
