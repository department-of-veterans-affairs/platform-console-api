# frozen_string_literal: true

require 'application_system_test_case'

class AppsTest < ApplicationSystemTestCase
  setup do
    login_as :john
    @team = teams(:three)
    @app = apps(:three)
  end

  test 'visiting the index' do
    visit team_apps_url(@team)
    assert_selector 'h1', text: 'Apps'
  end

  test 'should show app' do
    VCR.use_cassette('system/apps', record: :new_episodes) do
      visit team_app_url(@team, @app)
      assert_selector 'a', text: 'Overview'
      assert_selector 'h1', text: 'Latest Releases'
      assert_selector 'dt', text: 'Open Pull Requests'
      assert_selector 'dt', text: 'Branches'
      assert_selector 'dt', text: 'Open Issues'
      assert_selector 'dt', text: 'Tags'
      assert_selector 'dt', text: 'Latest Release'
    end
  end

  test 'should create app' do
    visit team_apps_url(@team)
    click_on 'New app'

    fill_in 'Name', with: @app.name

    click_on 'Create App'

    assert_text 'App was successfully created'
  end

  test 'should not create app with invalid repository' do
    VCR.use_cassette('system/apps', record: :new_episodes) do
      visit team_apps_url(@team)
      click_on 'New app'

      fill_in 'Name', with: @app.name
      fill_in 'app_github_repo', with: 'invalid-repository'

      click_on 'Create App'

      assert_text 'error prohibited this app from being saved'
    end
  end

  test 'should update App' do
    VCR.use_cassette('system/apps', record: :new_episodes) do
      visit team_app_url(@team, @app)
      click_on 'Settings', match: :first

      fill_in 'Name', with: 'App1A'
      fill_in 'app_github_repo', with: ''

      click_on 'Update App'

      assert_text 'App was successfully updated'
    end
  end

  test 'should update app with valid github repository' do
    VCR.use_cassette('system/apps', record: :new_episodes) do
      visit team_app_url(@team, @app)
      click_on 'Settings', match: :first

      fill_in 'app_github_repo', with: 'department-of-veterans-affairs/vets-api'

      click_on 'Update App'

      assert_text 'App was successfully updated'
    end
  end

  test 'should not update app with invalid github repository' do
    VCR.use_cassette('system/apps', record: :new_episodes) do
      visit team_app_url(@team, @app)
      click_on 'Settings', match: :first

      fill_in 'app_github_repo', with: 'invalid-repository'

      click_on 'Update App'

      assert_text 'error prohibited this app from being saved'
    end
  end

  test 'should destroy App' do
    visit edit_team_app_url(@team, @app)
    accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'App was successfully destroyed'
  end
end
