# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class DeploysTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/deploys') do
        visit team_app_deploys_url(@team, @app)
        assert_selector 'a', text: 'Deploys'
        click_on 'View Deploy', match: :first
        assert_selector 'h3', text: 'Jobs'
      end
    end
  end
end
