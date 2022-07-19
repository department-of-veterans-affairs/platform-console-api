# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class DeploymentsControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:jack)
        setup_omniauth_mock(@user) # this needs to be in until we fix the session token for argo auth
        @team = teams(:two)
        @app = apps(:two)
        @deployment = deployments(:one)
      end

      test 'should get index' do
        get v1_team_apps_url(@team), headers: api_auth_header(@user)
        assert_equal @team.apps.count, @response.parsed_body['data'].length
        assert_response :success
      end

      test 'should create deployment' do
        assert_difference('Deployment.count', +1) do
          post v1_team_app_deployments_url(@team, @app),
               params: { deployment: { name: @deployment.name, app_id: @app.id } },
               headers: api_auth_header(@user)
        end
        assert_equal @deployment.name, @response.parsed_body.dig('data', 'attributes', 'name')
        assert_response :created
      end

      test 'should show deployment' do
        VCR.use_cassette('api/deployments_controller') do
          get v1_team_app_deployment_url(@team, @app, @deployment), headers: api_auth_header(@user)
          assert_response :success
        end
      end

      test 'should update deployment' do
        patch v1_team_app_deployment_url(@team, @app, @deployment),
              params: { deployment: { name: 'deployment1A' } },
              headers: api_auth_header(@user)
        assert_equal 'deployment1A', @response.parsed_body.dig('data', 'attributes', 'name')
        assert_response :success
      end

      test 'should destroy deployment' do
        assert_difference('Deployment.count', -1) do
          delete v1_team_app_deployment_url(@team, @app, @deployment), headers: api_auth_header(@user)
        end

        assert_response :no_content
      end
    end
  end
end
