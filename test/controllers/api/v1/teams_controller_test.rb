# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class TeamsControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:john)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should get index' do
        get v1_teams_url, headers: api_auth_header(@user)
        assert_equal Team.count, @response.parsed_body['data'].length
        assert_response :success
      end

      test 'should create team with valid params' do
        assert_difference('Team.count', +1) do
          post v1_teams_url(@team), params: { team: { name: @app.name } }, headers: api_auth_header(@user)
        end
        assert_equal @app.name, @response.parsed_body.dig('data', 'attributes', 'name')
        assert_response :created
      end

      test 'should not create team with invalid params' do
        assert_no_difference('Team.count') do
          post v1_teams_url(@team), params: { team: { name: nil, team_id: nil } }, headers: api_auth_header(@user)
        end

        assert_response :unprocessable_entity
      end

      test 'should show team' do
        VCR.use_cassette('apps_controller') do
          get v1_team_app_url(@team, @app.id), headers: api_auth_header(@user)
          assert_equal @app.name, @response.parsed_body.dig('data', 'attributes', 'name')
          assert_equal @app.id, @response.parsed_body.dig('data', 'id').to_i
          assert_equal @team.id, @response.parsed_body.dig('data', 'relationships', 'team', 'data', 'id').to_i
          assert_response :success
        end
      end

      test 'should update app with valid params' do
        patch v1_team_app_url(@team, @app), params: { app: { name: 'App1 Updated' } }, headers: api_auth_header(@user)
        assert_equal 'App1 Updated', @response.parsed_body.dig('data', 'attributes', 'name')
        assert_response :success
      end

      test 'should not update app with invalid params' do
        patch v1_team_app_url(@team, @app), params: { app: { name: nil, team: nil } }, headers: api_auth_header(@user)
        assert_response :unprocessable_entity
      end

      test 'should destroy app' do
        assert_difference('App.count', -1) do
          delete v1_team_app_url(@team, @app), headers: api_auth_header(@user)
        end

        assert_response :no_content
      end
    end
  end
end
