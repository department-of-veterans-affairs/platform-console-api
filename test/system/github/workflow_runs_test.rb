# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowRunsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/workflow_runs') do
        visit team_app_workflow_run_path(@team, @app, 1_859_445_208)
        assert_selector 'a', text: 'Workflows'
        assert_selector 'a', text: 'All Jobs'
        assert_selector 'h3', text: 'Jobs'
        assert_selector(:link, nil, href: %r{workflow_run_jobs/\d+$})
      end
    end
  end
end
