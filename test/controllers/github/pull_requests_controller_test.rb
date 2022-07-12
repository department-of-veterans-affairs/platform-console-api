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
        get team_app_pull_requests_path(@team, @app)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/pull_requests_controller') do
        get "#{team_app_pull_requests_path(@team, @app)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id repo app_id github]
        assert(expected_keys.all? { |k| json_response['pull_requests'].first.key? k })
      end
    end
  end
end
