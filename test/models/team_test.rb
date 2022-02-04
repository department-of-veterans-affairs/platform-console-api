# frozen_string_literal: true

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test 'Team one should have memberships' do
    assert_equal(teams(:one).memberships.size, 2)
  end

  test 'Team one should have teams' do
    assert_equal(teams(:one).teams.size, 1)
  end

  test 'Team one should have users' do
    assert_equal(teams(:one).users.size, 1)
  end

  test 'Team two should not have memberships' do
    assert_equal(teams(:two).memberships.size, 0)
  end

  test 'Team two should not have teams' do
    assert_equal(teams(:two).teams.size, 0)
  end

  test 'Team two should not have users' do
    assert_equal(teams(:two).users.size, 0)
  end
end
