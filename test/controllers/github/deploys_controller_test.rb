# frozen_string_literal: true

require 'test_helper'

module Github
  class DeploysControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
      Github.send :remove_const, 'DEPLOY_WORKFLOW_FILE'
      Github.const_set 'DEPLOY_WORKFLOW_FILE', 'codeql.yml'
    end

    test 'should get index' do
      VCR.use_cassette('github/deploys_controller') do
        get team_app_github_repository_deploys_path(@team, @app, @app.github_repo)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/deploys_controller') do
        get "#{team_app_github_repository_deploys_path(@team, @app, @app.github_repo)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id node_id name path state created_at updated_at url html_url badge_url]
        assert(expected_keys.all? { |k| json_response['deploys'].first.key? k })
      end
    end

    test 'should show deploy' do
      VCR.use_cassette('github/deploys_controller', record: :new_episodes) do
        get team_app_github_repository_deploy_path(@team, @app, @app.github_repo, 17_929_736)
        assert_response :success
      end
    end

    test 'should show deploy in json format' do
      VCR.use_cassette('github/deploys_controller', record: :new_episodes) do
        get "#{team_app_github_repository_deploy_path(@team, @app, @app.github_repo, 17_929_736)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id node_id name path state created_at updated_at url html_url badge_url]
        assert(expected_keys.all? { |k| json_response['deploy'].key? k })
        assert_equal 17_929_736, json_response['deploy']['id']
      end
    end
  end
end
