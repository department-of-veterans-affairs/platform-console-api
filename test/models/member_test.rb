# frozen_string_literal: true

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
  end

  test 'valid member' do
    member = @team.members.build(user: jane)
    assert member.valid?
  end
end
