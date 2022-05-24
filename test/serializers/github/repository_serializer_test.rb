# frozen_string_literal: true

require 'test_helper'

module Github
  class RepositorySerializerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      @team = teams(:three)
      @app = apps(:three)
      VCR.use_cassette('github/repository') do
        @repository = Github::Repository.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/platform-console-api', @app.id
        )
        @hash = Github::RepositorySerializer.new(@repository).serializable_hash
      end
    end

    test 'should serialize with the correct attributes' do
      assert_equal @hash.dig(:data, :attributes).keys, %i[repo github app_id]
    end

    test 'should have the correct relationships' do
      assert_equal @hash.dig(:data, :relationships).keys, [:workflows]
    end

    test 'should have correct relationship links' do
      assert_equal @hash.dig(:data, :relationships, :workflows, :links, :related),
                   "/api/v1/teams/#{@app.team_id}/apps/#{@app.id}/workflows"
    end
  end
end
