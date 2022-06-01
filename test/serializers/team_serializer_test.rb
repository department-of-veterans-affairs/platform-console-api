# frozen_string_literal: true

require 'test_helper'

class TeamSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @team = teams(:three)
    @hash = TeamSerializer.new(@team).serializable_hash
  end

  test 'should serialize with the correct attributes' do
    assert_equal @hash.dig(:data, :attributes).keys, %i[name created_at updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, %i[owner apps]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "test.host/api/v1/teams/#{@team.id}"
  end

  test 'should have correct relationship links' do
    assert_equal @hash.dig(:data, :relationships, :apps, :links, :related),
                 "test.host/api/v1/teams/#{@team.id}/apps"
    assert_equal @hash.dig(:data, :relationships, :owner, :links, :related),
                 "test.host/api/v1/users/#{@team.owner_id}"
  end
end
