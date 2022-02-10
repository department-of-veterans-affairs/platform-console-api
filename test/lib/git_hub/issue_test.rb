# frozen_string_literal: true

require 'test_helper'

module GitHub
  class IssueTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('git_hub/issue') do
        @issue = GitHub::Issue.new('vets-api', '24')
      end
    end

    test 'can be created with a valid repo and issue number' do
      assert_instance_of GitHub::Issue, @issue
      assert_instance_of Sawyer::Resource, @issue.gh_info
      assert_equal 24, @issue.gh_info.number
    end

    test 'lists issue comments' do
      VCR.use_cassette('git_hub/issue', record: :new_episodes) do
        issue_comments = @issue.comments
        assert_kind_of Array, issue_comments
        assert_not_nil issue_comments.first.issue_url
      end
    end

    test 'lists all issues for a repository' do
      VCR.use_cassette('git_hub/issue', record: :new_episodes) do
        issues = GitHub::Issue.all('vets-api')
        assert_kind_of Array, issues
        assert_not_nil issues.first.number
      end
    end
  end
end
