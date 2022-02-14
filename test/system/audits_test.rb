# frozen_string_literal: true

require 'application_system_test_case'

class AuditsTest < ApplicationSystemTestCase
  setup do
    login_as :john
    @team_one = teams(:one)
    @team_two = teams(:two)
    @app_one = apps(:one)
    @app_two = apps(:two)
  end

  test 'visiting the index' do
    visit audits_url
    assert_selector 'h1', text: 'Audits'
    assert_selector 'th', text: 'ITEM TYPE'
    assert_selector 'td', text: 'App'
    assert_selector 'td', text: 'Team'
    assert_selector 'div', text: 'Details'

    click_on 'Details', match: :first
    assert_selector 'span', text: 'Hide Details'
  end
end
