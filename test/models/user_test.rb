# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'John should have memberships' do
    assert_equal(users(:john).memberships.size, 1)
  end

  test 'John should have teams' do
    assert_equal(users(:john).teams.size, 1)
  end

  test 'Jane should not have memberships' do
    assert_equal(users(:jane).memberships.size, 0)
  end

  test 'Jane should not have teams' do
    assert_equal(users(:jane).teams.size, 0)
  end
end
