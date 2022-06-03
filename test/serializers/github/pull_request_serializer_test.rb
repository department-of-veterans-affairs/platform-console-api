# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestSerializerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      @team = teams(:three)
      @app = apps(:three)
      VCR.use_cassette('github/pull_request') do
        @pull_request = Github::PullRequest.new(
          ENV.fetch('GITHUB_ACCESS_TOKEN'), 'department-of-veterans-affairs/platform-console-api', '10', @app.id
        )
        @hash = Github::PullRequestSerializer.new(@pull_request).serializable_hash
      end
    end

    test 'should serialize with the correct attributes' do
      assert_equal @hash.dig(:data, :attributes).keys, %i[repo github app_id]
    end

    test 'should have the correct relationships' do
      assert_equal @hash.dig(:data, :relationships).keys, [:app]
    end

    test 'should have correct relationship links' do
      assert_equal @hash.dig(:data, :relationships, :app, :links, :related),
                   "test.host/api/v1/teams/#{@app.team_id}/apps/#{@app.id}"
    end
  end
end
