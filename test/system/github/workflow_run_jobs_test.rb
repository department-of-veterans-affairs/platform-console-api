# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowRunJobsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/workflow_run_jobs') do
        visit team_app_workflow_run_job_path(@team, @app, 5_487_333_352, workflow_run_id: 1_959_838_157)
        assert_selector 'a', text: 'Workflows'
        assert_selector 'a', text: 'All Jobs'
        assert_selector 'p', text: 'Logs'
        assert_selector(:link, nil, title: 'Download Logs')
        assert_selector(:link, nil, href: %r{workflow_run_jobs/\d+$})
        assert_selector(:button, nil, title: 'Restart Run')

        # TODO: No route matches, missing required keys: [:id] in workflow_runs_controller.rb:47
        click_on 'Restart Run', match: :first
        assert_selector 'p', text: 'Workflow run was sucessfully restarted'
      end
    end
  end
end
