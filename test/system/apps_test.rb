# frozen_string_literal: true

require 'application_system_test_case'

class AppsTest < ApplicationSystemTestCase
  setup do
    login_as :john
    @team = teams(:two)
    @app = apps(:two)
    @deployment = deployments(:two)
  end

  test 'visiting the index' do
    visit team_apps_url(@team)
    assert_selector 'h1', text: 'Apps'
  end

  test 'should show app and generate a token' do
    visit team_app_url(@team, @app)
    assert_selector 'h3', text: "App: #{@app.name}"
  end

  test 'should create app' do
    visit team_apps_url(@team)
    click_on 'New app'

    fill_in 'Name', with: @app.name

    click_on 'Create App'

    assert_text 'App was successfully created'
  end

  test 'should update App' do
    visit team_app_url(@team, @app)
    click_on 'Edit', match: :first

    fill_in 'Name', with: 'App1A'

    click_on 'Update App'

    assert_text 'App was successfully updated'
  end

  test 'should destroy App' do
    visit team_app_url(@team, @app)
    accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'App was successfully destroyed'
  end
end
