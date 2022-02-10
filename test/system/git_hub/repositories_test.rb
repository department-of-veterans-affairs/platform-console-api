# frozen_string_literal: true

require 'application_system_test_case'

module GitHub
  class RepositoriesTest < ApplicationSystemTestCase
    # setup do
    #   @git_hub_repository = git_hub_repositories(:one)
    # end

    # test 'visiting the index' do
    #   visit git_hub_repositories_url
    #   assert_selector 'h1', text: 'Repositories'
    # end

    # test 'should create repository' do
    #   visit git_hub_repositories_url
    #   click_on 'New repository'

    #   click_on 'Create Repository'

    #   assert_text 'Repository was successfully created'
    #   click_on 'Back'
    # end

    # test 'should update Repository' do
    #   visit git_hub_repository_url(@git_hub_repository)
    #   click_on 'Edit this repository', match: :first

    #   click_on 'Update Repository'

    #   assert_text 'Repository was successfully updated'
    #   click_on 'Back'
    # end

    # test 'should destroy Repository' do
    #   visit git_hub_repository_url(@git_hub_repository)
    #   click_on 'Destroy this repository', match: :first

    #   assert_text 'Repository was successfully destroyed'
    # end
  end
end
