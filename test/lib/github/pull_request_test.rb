# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/pull_request') do
        @pull_request = Github::PullRequest.new('platform-console-api', '10')
      end
    end

    test 'can be created with a valid repo and pull request number' do
      assert_instance_of Github::PullRequest, @pull_request
      assert_instance_of Sawyer::Resource, @pull_request.github
      assert_equal 10, @pull_request.github.number
    end

    test 'lists comments for the pull request' do
      VCR.use_cassette('github/pull_request', record: :new_episodes) do
        comments = @pull_request.comments
        assert_kind_of Array, comments
        assert_not_nil comments.first.pull_request_review_id
      end
    end

    test 'shows correct merged? status' do
      VCR.use_cassette('github/pull_request', record: :new_episodes) do
        assert_equal true, @pull_request.merged?
      end
    end

    test 'lists workflow runs for the pull request branch' do
      VCR.use_cassette('github/pull_request', record: :new_episodes) do
        workflow_runs = @pull_request.workflow_runs.workflow_runs
        assert_kind_of Array, workflow_runs
        assert_not_nil workflow_runs.first.workflow_id
      end
    end

    test 'lists all pull_requests for a repository' do
      VCR.use_cassette('github/pull_request', record: :new_episodes) do
        pull_requests = Github::PullRequest.all('vets-api')[:pull_requests]
        assert_kind_of Array, pull_requests
        assert_not_nil pull_requests.first.number
      end
    end
  end
end
