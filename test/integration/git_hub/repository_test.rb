# frozen_string_literal: true

require 'test_helper'

module GitHub
  class RepositoryTest < ActionDispatch::IntegrationTest
    test 'can be created with a valid repository' do
      VCR.use_cassette('git_hub/repository') do
        repo = GitHub::Repository.new('vets-api')
        assert_instance_of GitHub::Repository, repo
        assert_instance_of Sawyer::Resource, repo.gh_info
        assert_equal 'vets-api', repo.gh_info.name
      end
    end

    test 'cannot be created with an invalid repository' do
      VCR.use_cassette('git_hub/invalid_repository') do
        assert_raises Octokit::NotFound do
          GitHub::Repository.new('invalid-repository')
        end
      end
    end
  end
end
