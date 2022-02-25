# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class PullRequestsTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/pull_requests') do
        visit team_app_github_repository_pull_requests_url(@team, @app, @app.github_repo)
        assert_selector 'a.border-indigo-500.border-b-2', text: 'Pull Requests'
        click_on 'Workflow Runs', match: :first
        assert_selector 'a', text: 'Dispatch a Workflow'
      end
    end
  end
end
