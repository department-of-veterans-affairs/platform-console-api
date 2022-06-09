# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class DeploymentsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:jack)
        setup_omniauth_mock(@user)
        @team = teams(:two)
        @app = apps(:two)
        @deployment = deployments(:one)
      end

      test 'should get index' do
        get v1_team_apps_url(@team)
        assert_equal App.count, @response.parsed_body['data'].length
        assert_response :success
      end

      test 'should create deployment' do
        assert_difference('Deployment.count') do
          post v1_team_app_deployments_url(@team, @app),
               params: { deployment: { name: @deployment.name, app_id: @app.id } }
        end

        assert_response :created
      end

      # TODO: fix show
      test 'should show deployment' do
        VCR.use_cassette('system/success') do
          get v1_team_app_deployment_url(@team, @app, @deployment)
          assert_response :success
        end
      end

      test 'should update deployment' do
        patch v1_team_app_deployment_url(@team, @app, @deployment), params: { deployment: { name: 'deployment1A' } }
        assert_response :ok
      end

      test 'should destroy deployment' do
        assert_difference('Deployment.count', -1) do
          delete v1_team_app_deployment_url(@team, @app, @deployment)
        end

        assert_response :no_content
      end
    end
  end
end
