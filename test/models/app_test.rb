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

  test 'invalid app' do
    app = @team.apps.build(name: nil, team: @team)
    assert_not app.valid?
  end
end
