# frozen_string_literal: true

require 'test_helper'

module Github
  class IssueTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/issue') do
        @issue = Github::Issue.new(ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', '24')
      end
    end

    test 'can be created with a valid repo and issue number' do
      VCR.use_cassette('github/issue', record: :new_episodes) do
        assert_instance_of Github::Issue, @issue
        assert_instance_of Sawyer::Resource, @issue.github
        assert_equal 24, @issue.github.number
      end
    end

    test 'lists issue comments' do
      VCR.use_cassette('github/issue', record: :new_episodes) do
        issue_comments = @issue.comments
        assert_kind_of Array, issue_comments
        assert_not_nil issue_comments.first.issue_url
      end
    end

    test 'lists all issues for a repository' do
      VCR.use_cassette('github/issue', record: :new_episodes) do
        issues = Github::Issue.all(ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api')[:issues]
        assert_kind_of Array, issues
        assert_not_nil issues.first.number
      end
    end
  end
end
