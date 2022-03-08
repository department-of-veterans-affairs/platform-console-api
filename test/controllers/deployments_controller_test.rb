# frozen_string_literal: true

require 'test_helper'

class DeploymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jack)
    setup_omniauth_mock(@user)
    @app = apps(:two)
    @deployment = deployments(:one)
  end

  test 'should get index' do
    get app_deployments_url(@app)
    assert_response :success
  end

  test 'should get new' do
    get new_app_deployment_url(@app)
    assert_response :success
  end

  test 'should create deployment' do
    assert_difference('Deployment.count') do
      post app_deployments_url(@app), params: { deployment: { name: @deployment.name, app_id: @app.id } }
    end

    assert_redirected_to app_deployment_url(@app, Deployment.last)
  end

  test 'should show deployment' do
    VCR.use_cassette('system/success', record: :new_episodes) do
      get app_deployment_url(@app, @deployment)
      assert_response :success
    end
  end

  test 'should get edit' do
    get edit_app_deployment_url(@app, @deployment)
    assert_response :success
  end

  test 'should update deployment' do
    patch app_deployment_url(@app, @deployment), params: { deployment: { name: 'deployment1A' } }
    assert_redirected_to app_deployment_url(@app, @deployment)
  end

  test 'should destroy deployment' do
    assert_difference('Deployment.count', -1) do
      delete app_deployment_url(@app, @deployment)
    end

    assert_redirected_to app_deployments_url(@app)
  end
end
