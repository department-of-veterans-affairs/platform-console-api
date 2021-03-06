# frozen_string_literal: true

require 'application_system_test_case'
require 'test_helper'

class DeploymentsTest < ApplicationSystemTestCase
  setup do
    @user = users :john
    omniauth_login_as(@user)
    @team = teams(:two)
    @app = apps(:two)
    @deployment = deployments(:one)
    ENV['ARGO_API'] = 'true'
  end

  test 'visiting the index' do
    visit team_app_deployments_url(@team, @app)
    assert_selector 'h3', text: 'Argo Deployments'
  end

  test 'should show deployment with a successful jwt' do
    VCR.use_cassette('system/keycloak_jwt') do
      visit team_app_deployment_url(@team, @app, @deployment)
      assert_selector 'h3', text: 'Argo Deployment Stats'
      assert_selector 'dt', text: 'App Health'
      assert_selector 'dd', text: 'Healthy'
      assert_selector 'dt', text: 'Current Commit Info'
      assert_selector 'dd', text: 'Status: Synced'
      assert_selector 'dt', text: 'Previous Commit Info'
    end
  end

  test 'should show error when bad jwt' do
    VCR.use_cassette('system/deployments_401') do
      @user = users :jack
      login_as :jack
      visit team_app_deployment_url(@team, @app, @deployment)
      assert_selector 'dt', text: '401 - no session information'
      assert_selector 'dd', text: 'Error: Something went wrong with the Argo API call, please try again'
    end
  end

  test 'should get the current revision info' do
    VCR.use_cassette('system/current_revision_success') do
      visit team_app_deployment_url(@team, @app, @deployment)
      assert_selector 'h3', text: 'Argo Deployment Stats'
      assert_selector 'dt', text: 'App Health'
      assert_selector 'dd', text: 'Healthy'
      assert_selector 'dt', text: 'Current Commit Info'
      assert_selector 'dd', text: 'Status: Synced'
      assert_selector 'dd', text: 'Author: May Zhang'
      assert_selector 'dt', text: 'Previous Commit Info'
    end
  end

  test 'should create deployment' do
    VCR.use_cassette('system/current_revision_success') do
      visit team_app_deployments_url(@team, @app)
      click_on 'New Deployment'

      fill_in 'Name', with: @deployment.name
      click_on 'Create Deployment'

      assert_text 'Deployment was successfully created'
    end
  end

  test 'should update Deployment' do
    VCR.use_cassette('system/current_revision_success') do
      visit team_app_deployment_url(@team, @app, @deployment)
      click_on 'Edit this deployment', match: :first

      fill_in 'Name', with: @deployment.name
      click_on 'Update Deployment'

      assert_text 'Deployment was successfully updated'
    end
  end

  test 'should destroy Deployment' do
    VCR.use_cassette('system/current_revision_success') do
      visit team_app_deployment_url(@team, @app, @deployment)
      click_on 'Destroy this deployment', match: :first
      page.driver.browser.switch_to.alert.accept
      assert_text 'Deployment was successfully destroyed'
    end
  end
end
