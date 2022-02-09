# frozen_string_literal: true

require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  setup do
    @team = teams(:one)
  end

  test 'valid team' do
    @team.update_attribute(name: "Console Services")
    assert @team.valid?
  end

  test 'valid team with papertrail versions' do
    @team.update_attribute(name: "Console Services")
    assert @team.valid?
    assert_not_nil @team.versions
  end

  test 'invalid team' do
    team = Team.new
    assert_not team.valid?
  end
end
