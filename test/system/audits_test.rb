# frozen_string_literal: true

require 'application_system_test_case'

class AuditsTest < ApplicationSystemTestCase
  setup do
    login_as :john

    (1..3).each do |t|
      new_app = apps(:one).dup
      new_app.name = "App #{t}"
      new_app.save

      new_team = teams(:one).dup
      new_team.name = "Team #{t}"
      new_team.save
    end
  end

  test 'visiting the index' do
    visit audits_url
    assert_selector 'h1', text: 'Audits'
    assert_selector 'th', text: 'ITEM TYPE'
    assert_selector 'td', text: 'App'
    assert_selector 'td', text: 'Team'
    assert_selector 'div', text: 'DETAILS'

    click_on 'DETAILS', match: :first
    assert_selector 'span', text: 'Hide Details'
  end
end
