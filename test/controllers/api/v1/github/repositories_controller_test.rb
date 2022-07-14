# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class RepositoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:john)
        @team = teams(:three)
        @app = apps(:four)
      end

      test 'gets the repository' do
        VCR.use_cassette('api/github/repositories_controller', record: :new_episodes) do
          get v1_team_app_repository_url(@team, @app), headers: api_auth_header(@user)
          assert_equal 'department-of-veterans-affairs/platform-console-api', @response.parsed_body.dig('data', 'id')
          assert_equal @app.id, @response.parsed_body.dig('data', 'attributes', 'app_id')
          assert_response :success
        end
      end
    end
  end
end
