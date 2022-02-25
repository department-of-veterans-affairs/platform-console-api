# frozen_string_literal: true

require 'application_system_test_case'

module Github
  class RepositoriesTest < ApplicationSystemTestCase
    setup do
      login_as :john
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'visiting the index' do
      VCR.use_cassette('system/github/repositories') do
        visit team_app_github_repository_path(@team, @app, @app.github_repo)
        assert_selector 'a.border-indigo-500.border-b-2', text: 'Repository'
        assert_selector 'h1', text: 'Repository: department-of-veterans-affairs/vets-api'
      end
    end
  end
end
