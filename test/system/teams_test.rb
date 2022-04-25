# frozen_string_literal: true

require 'application_system_test_case'

class TeamsTest < ApplicationSystemTestCase
  setup do
    login_as :john
    @team = teams(:one)
  end

  test 'visiting the index' do
    visit teams_url
    assert_selector 'h1', text: 'Teams'
  end

  test 'should create team' do
    visit teams_url
    click_on 'New team'

    fill_in 'Name', with: @team.name
    click_on 'Create Team'

    assert_text 'Team was successfully created'
  end

  test 'should not create invalid team' do
    visit teams_url
    click_on 'New team'

    click_on 'Create Team'

    assert_text "Name can't be blank"
  end

  test 'should update Team' do
    visit team_url(@team)
    click_on 'Edit this team', match: :first

    fill_in 'Name', with: @team.name
    click_on 'Update Team'

    assert_text 'Team was successfully updated'
  end

  test 'should not update invalid team' do
    visit team_url(@team)
    click_on 'Edit this team', match: :first

    fill_in 'Name', with: ''
    click_on 'Update Team'

    assert_text "Name can't be blank"
  end

  test 'should destroy Team' do
    visit team_url(@team)
    click_on 'Destroy this team', match: :first
    page.driver.browser.switch_to.alert.accept

    assert_text 'Team was successfully destroyed'
  end
end
