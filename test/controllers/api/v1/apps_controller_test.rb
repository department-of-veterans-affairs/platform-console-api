# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class AppsControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:john)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should get index' do
        get v1_team_apps_url(@team), headers: api_auth_header(@user)
        assert_equal @team.apps.count, @response.parsed_body['data'].length
        assert_response :success
      end

      test 'should create app with valid params' do
        assert_difference('App.count', +1) do
          post v1_team_apps_url(@team), params: { app: { name: @app.name, team_id: @team.id } },
                                        headers: api_auth_header(@user)
        end

        assert_equal @app.name, @response.parsed_body.dig('data', 'attributes', 'name')
        assert_equal @team.id, @response.parsed_body.dig('data', 'relationships', 'team', 'data', 'id').to_i
        assert_response :created
      end

      test 'should not create app with invalid params' do
        assert_no_difference('App.count') do
          post v1_team_apps_url(@team), params: { app: { name: nil, team_id: nil } }, headers: api_auth_header(@user)
        end

        assert_response :unprocessable_entity
      end

      test 'should show app' do
        VCR.use_cassette('api/apps_controller') do
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
