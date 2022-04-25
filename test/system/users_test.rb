# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:john)
    login_as :john
    @team = teams(:one)
    @app = apps(:one)
  end

  test 'should update User' do
    VCR.use_cassette('system/users', record: :new_episodes) do
      visit edit_user_url(@user)

      click_on 'Update User'

      assert_text 'User was successfully updated'
    end
  end
end
