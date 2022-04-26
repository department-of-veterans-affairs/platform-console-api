# frozen_string_literal: true

require 'test_helper'

class DeploymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jack)
    setup_omniauth_mock(@user)
    @team = teams(:two)
    @app = apps(:two)
    @deployment = deployments(:one)
    stub_argo_requests
  end

  test 'should get index' do
    get team_app_deployments_url(@team, @app)
    assert_response :success
  end

  test 'should get new' do
    get new_team_app_deployment_url(@team, @app)
    assert_response :success
  end

  test 'should create deployment' do
    assert_difference('Deployment.count') do
      post team_app_deployments_url(@team, @app), params: { deployment: { name: @deployment.name, app_id: @app.id } }
    end

    assert_redirected_to team_app_deployment_url(@team, @app, Deployment.last)
  end

  test 'should show deployment' do
    VCR.use_cassette('system/success') do
      get team_app_deployment_url(@team, @app, @deployment)
      assert_response :success
    end
  end

  test 'should get edit' do
    get edit_team_app_deployment_url(@team, @app, @deployment)
    assert_response :success
  end

  test 'should update deployment' do
    patch team_app_deployment_url(@team, @app, @deployment), params: { deployment: { name: 'deployment1A' } }
    assert_redirected_to team_app_deployment_url(@team, @app, @deployment)
  end

  test 'should destroy deployment' do
    assert_difference('Deployment.count', -1) do
      delete team_app_deployment_url(@team, @app, @deployment)
    end

    assert_redirected_to team_app_deployments_url(@team, @app)
  end
end
