# frozen_string_literal: true

require 'application_system_test_case'
require 'test_helper'

class DeploymentsTest < ApplicationSystemTestCase
  setup do
    @user = users :jack
    login_as :jack
    @app = apps(:two)
    @deployment = deployments(:one)
    @connected_app = connected_apps(:one)
  end

  test 'visiting the index' do
    visit app_deployments_url(@app)
    assert_selector 'h1', text: 'Deployments'
  end

  test 'should show app' do
    VCR.use_cassette('system/success') do
      visit app_deployment_url(@app, @deployment)
      assert_selector 'h3', text: 'Argo Info'
      assert_selector 'dt', text: 'App Health'
      assert_selector 'dd', text: 'Healthy'
      assert_selector 'dt', text: 'Current Commit Info'
      assert_selector 'dd', text: 'Status: Synced'
      assert_selector 'dt', text: 'Previous Commit Info'
    end
  end

  test 'should show error when bad jwt' do
    VCR.use_cassette('system/deployments_401') do
      visit app_deployment_url(@app, @deployment)
      assert_selector 'dt', text: '401 - no session information'
      assert_selector 'dd', text: 'Error: Something went wrong with the Argo API call, please try again'
    end
  end

  test 'should create deployment' do
    visit app_deployments_url(@app)
    click_on 'New deployment'

    fill_in 'Name', with: @deployment.name
    click_on 'Create Deployment'

    assert_text 'Deployment was successfully created'
    click_on 'Back'
  end

  test 'should update Deployment' do
    visit app_deployment_url(@app, @deployment)
    click_on 'Edit this deployment', match: :first

    fill_in 'Name', with: @deployment.name
    click_on 'Update Deployment'

    assert_text 'Deployment was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Deployment' do
    visit app_deployment_url(@app, @deployment)
    click_on 'Destroy this deployment', match: :first
    page.driver.browser.switch_to.alert.accept

    assert_text 'Deployment was successfully destroyed'
  end
end