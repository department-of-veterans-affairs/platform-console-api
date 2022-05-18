require 'test_helper'

class TeamSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @team = teams(:three)
    @hash = TeamSerializer.new(@team).serializable_hash
  end

  test 'should serialize with the correct attributes' do
   assert_equal @hash.dig(:data, :attributes).keys, [:name, :created_at, :updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, [:owner, :apps]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "#{ENV['BASE_URL']}/api/v1/teams/#{@team.id}"
  end
end
