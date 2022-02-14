# frozen_string_literal: true

# require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
    @user = users(:jane)
  end

  test 'valid member' do
    member = @team.members.build(user: @user)
    assert member.valid?
    assert_equal @team.members.size, 2
    assert_equal @team.users.size, 2
  end
end
