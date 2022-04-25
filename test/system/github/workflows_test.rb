# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/workflows', record: :new_episodes) do
        visit team_app_workflows_path(@team, @app)
        assert_selector 'a', text: 'Workflows'
        assert_selector 'a', text: 'Dispatch a Workflow'
        click_on 'View', match: :first
        assert_selector 'h3', text: 'Jobs'
      end
    end

    test 'dispatching a new workflow' do
      VCR.use_cassette('system/github/workflows', record: :new_episodes) do
        visit new_team_app_workflow_run_path(@team, @app)
        select 'CodeQL', from: 'workflow_id'
        fill_in 'Ref', with: 'master'
        click_on 'Dispatch'

        assert_selector 'p', text: 'Workflow was successfully dispatched'
      end
    end
  end
end
