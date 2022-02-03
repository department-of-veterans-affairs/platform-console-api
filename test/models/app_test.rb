# frozen_string_literal: true

require 'test_helper'

class AppTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
  end

  test "valid app" do
    app = @team.apps.build(name: 'New App 1', team_id: @team.id)
    assert app.valid?
  end

  test "invalid app" do
    app = @team.apps.build(name: nil, team_id: @team.id)
    refute app.valid?
  end
end
