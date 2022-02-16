# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestsControllerTest < ActionDispatch::IntegrationTest
    # setup do
    #   @github_pull_request = github_pull_requests(:one)
    # end

    # test 'should get index' do
    #   get github_pull_requests_url
    #   assert_response :success
    # end

    # test 'should get new' do
    #   get new_github_pull_request_url
    #   assert_response :success
    # end

    # test 'should create github_pull_request' do
    #   assert_difference('Github::PullRequest.count') do
    #     post github_pull_requests_url, params: { github_pull_request: { show: @github_pull_request.show } }
    #   end

    #   assert_redirected_to github_pull_request_url(Github::PullRequest.last)
    # end

    # test 'should show github_pull_request' do
    #   get github_pull_request_url(@github_pull_request)
    #   assert_response :success
    # end

    # test 'should get edit' do
    #   get edit_github_pull_request_url(@github_pull_request)
    #   assert_response :success
    # end

    # test 'should update github_pull_request' do
    #   patch github_pull_request_url(@github_pull_request),
    #         params: { github_pull_request: { show: @github_pull_request.show } }
    #   assert_redirected_to github_pull_request_url(@github_pull_request)
    # end

    # test 'should destroy github_pull_request' do
    #   assert_difference('Github::PullRequest.count', -1) do
    #     delete github_pull_request_url(@github_pull_request)
    #   end

    #   assert_redirected_to github_pull_requests_url
    # end
  end
end
