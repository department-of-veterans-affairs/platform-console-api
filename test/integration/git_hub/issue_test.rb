# frozen_string_literal: true

require 'test_helper'

module GitHub
  class IssueTest < ActionDispatch::IntegrationTest
    test 'can be created with a valid repo and issue number' do
      VCR.use_cassette('git_hub/issue') do
        issue = GitHub::Issue.new('vets-api', '24')
        assert_instance_of GitHub::Issue, issue
        assert_instance_of Sawyer::Resource, issue.gh_info
        assert_equal 24, issue.gh_info.number
      end
    end
  end
end
