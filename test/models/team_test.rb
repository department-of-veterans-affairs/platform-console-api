# frozen_string_literal: true

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
  end

  test 'valid team' do
    @team.update(name: 'Console Services')
    assert @team.valid?
  end

  test 'valid team with papertrail versions' do
    @team.update(name: 'Console Services')
    assert @team.valid?
    assert_not_nil @team.versions
  end

  test 'invalid team' do
    team = Team.new
    assert_not team.valid?
  end

  test 'team with team members' do
    assert_equal(@team.team_members.size, 2)
    assert_equal(@team.users.size, 2)
  end

  test 'team without team members' do
    @team = teams(:two)
    assert_equal(@team.team_members.size, 0)
    assert_equal(@team.users.size, 0)
  end
end
