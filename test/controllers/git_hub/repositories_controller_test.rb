# frozen_string_literal: true

require 'test_helper'

module GitHub
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @git_hub_repository = git_hub_repositories(:one)
    end

    test 'should get index' do
      get git_hub_repositories_url
      assert_response :success
    end

    test 'should get new' do
      get new_git_hub_repository_url
      assert_response :success
    end

    test 'should create git_hub_repository' do
      assert_difference('GitHub::Repository.count') do
        post git_hub_repositories_url, params: { git_hub_repository: {} }
      end

      assert_redirected_to git_hub_repository_url(GitHub::Repository.last)
    end

    test 'should show git_hub_repository' do
      get git_hub_repository_url(@git_hub_repository)
      assert_response :success
    end

    test 'should get edit' do
      get edit_git_hub_repository_url(@git_hub_repository)
      assert_response :success
    end

    test 'should update git_hub_repository' do
      patch git_hub_repository_url(@git_hub_repository), params: { git_hub_repository: {} }
      assert_redirected_to git_hub_repository_url(@git_hub_repository)
    end

    test 'should destroy git_hub_repository' do
      assert_difference('GitHub::Repository.count', -1) do
        delete git_hub_repository_url(@git_hub_repository)
      end

      assert_redirected_to git_hub_repositories_url
    end
  end
end
