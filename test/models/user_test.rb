# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = users :john
    assert user.valid?
  end

  test 'should not save user without email' do
    user = User.new
    assert_not user.save
  end
end
