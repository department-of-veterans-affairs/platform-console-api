# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class RepositoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:john)
        setup_omniauth_mock(@user)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should get index' do
        VCR.use_cassette('api/github/repositories_controller') do
          get v1_team_app_repository_url(@team, @app, 'department-of-veterans-affairs/platform-console-api')
          assert_equal 'department-of-veterans-affairs/platform-console-api', @response.parsed_body.dig('data', 'id')
          assert_equal @app.id, @response.parsed_body.dig('data', 'attributes', 'app_id')
          assert_response :success
        end
      end
    end
  end
end
