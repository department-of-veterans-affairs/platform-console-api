# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/pull_requests_controller') do
        get team_app_pull_requests_path(@team, @app, @app.github_repo)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/pull_requests_controller') do
        get "#{team_app_pull_requests_path(@team, @app, @app.github_repo)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[url id node_id html_url diff_url patch_url issue_url number state locked title user body
                           created_at updated_at closed_at merged_at merge_commit_sha assignee assignees
                           requested_reviewers requested_teams labels milestone draft commits_url review_comments_url
                           review_comment_url comments_url statuses_url head base _links author_association auto_merge
                           active_lock_reason]
        assert(expected_keys.all? { |k| json_response['pull_requests'].first.key? k })
      end
    end

    test 'should show pull request' do
      VCR.use_cassette('github/pull_requests_controller') do
        get team_app_pull_requests_path(@team, @app, @app.github_repo, 2)
        assert_response :success
      end
    end
  end
end
