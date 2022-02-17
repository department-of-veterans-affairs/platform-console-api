# frozen_string_literal: true

require 'test_helper'

class AppTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
  end

  test 'valid app' do
    app = @team.apps.build(name: 'New App 1', team: @team)
    assert app.valid?
  end

  test 'valid app with papertrail versions' do
    app = @team.apps.new(name: 'New App 1', team_id: @team.id)
    assert app.valid?
    assert_not_nil app.versions
  end

  test 'invalid app' do
    app = @team.apps.build(name: nil, team: @team)
    assert_not app.valid?
  end
end
