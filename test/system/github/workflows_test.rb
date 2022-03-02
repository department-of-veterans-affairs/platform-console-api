# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/workflows') do
        visit team_app_workflows_path(@team, @app)
        assert_selector 'a', text: 'Workflows'
        assert_selector 'a', text: 'Dispatch a Workflow'
        click_on 'View', match: :first
        assert_selector 'h3', text: 'Jobs'
      end
    end
  end
end
