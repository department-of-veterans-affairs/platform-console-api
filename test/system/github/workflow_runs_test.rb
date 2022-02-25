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
        visit team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                    1_859_445_208)
        assert_selector 'a.border-indigo-500.border-b-2', text: 'Workflows'
        assert_selector 'a', text: 'All Jobs'
        assert_selector 'h3', text: 'Jobs'
        assert_selector(:link, nil, href: %r{workflow_run_jobs/\d+$})
      end
    end
  end
end
