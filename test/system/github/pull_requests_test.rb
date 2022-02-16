# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class PullRequestsTest < ApplicationSystemTestCase
    # setup do
    #   @github_pull_request = github_pull_requests(:one)
    # end

    # test 'visiting the index' do
    #   visit github_pull_requests_url
    #   assert_selector 'h1', text: 'Pull requests'
    # end

    # test 'should create pull request' do
    #   visit github_pull_requests_url
    #   click_on 'New pull request'

    #   fill_in 'Show', with: @github_pull_request.show
    #   click_on 'Create Pull request'

    #   assert_text 'Pull request was successfully created'
    #   click_on 'Back'
    # end

    # test 'should update Pull request' do
    #   visit github_pull_request_url(@github_pull_request)
    #   click_on 'Edit this pull request', match: :first

    #   fill_in 'Show', with: @github_pull_request.show
    #   click_on 'Update Pull request'

    #   assert_text 'Pull request was successfully updated'
    #   click_on 'Back'
    # end

    # test 'should destroy Pull request' do
    #   visit github_pull_request_url(@github_pull_request)
    #   click_on 'Destroy this pull request', match: :first

    #   assert_text 'Pull request was successfully destroyed'
    # end
  end
end
