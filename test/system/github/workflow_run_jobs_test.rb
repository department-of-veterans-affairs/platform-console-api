# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class WorkflowRunJobsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/workflow_run_jobs') do
        visit team_app_workflow_run_job_path(@team, @app, 5_204_164_825, workflow_run_id: 1_848_333_333)
        assert_selector 'a.border-indigo-500.border-b-2', text: 'Workflows'
        assert_selector 'a', text: 'All Jobs'
        assert_selector 'p', text: 'Logs'
        assert_selector(:link, nil, title: 'Download Logs')
        assert_selector(:link, nil, href: %r{workflow_run_jobs/\d+$})
      end
    end
  end
end