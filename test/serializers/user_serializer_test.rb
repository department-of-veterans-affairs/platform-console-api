require 'test_helper'

class TeamSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @hash = UserSerializer.new(@user).serializable_hash
  end

  test 'should serialize with the correct attributes' do
   assert_equal @hash.dig(:data, :attributes).keys, [:name, :email, :created_at, :updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, [:teams]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "#{ENV['BASE_URL']}/api/v1/users/#{@user.id}"
  end
end
