# frozen_string_literal: true

require 'application_system_test_case'

class AuditsTest < ApplicationSystemTestCase
  setup do
    login_as :john
    apps(:one)
    teams(:one)

    app = App.first
    app.name = 'App name update'
    app.save

    team = Team.first
    team.name = 'Team name update'
    team.save
  end

  test 'visiting the index' do
    visit audits_url
    assert_selector 'h1', text: 'Audits'
    assert_selector 'th', text: 'ITEM TYPE'
    assert_selector 'td', text: 'App'
    assert_selector 'td', text: 'Team'
    assert_selector 'div', text: 'DETAILS'

    click_on 'Show', match: :first
    assert_selector 'button', text: 'Hide'
  end
end
