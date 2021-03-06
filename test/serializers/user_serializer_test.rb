# frozen_string_literal: true

require 'test_helper'

class UserSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @hash = UserSerializer.new(@user).serializable_hash
  end

  test 'should serialize with the correct attributes' do
    assert_equal @hash.dig(:data, :attributes).keys, %i[name email created_at updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, [:teams]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "test.host/api/v1/users/#{@user.id}"
  end

  test 'should have correct relationship links' do
    assert_equal @hash.dig(:data, :relationships, :teams, :links, :related),
                 "test.host/api/v1/users/#{@user.id}/teams"
  end
end
