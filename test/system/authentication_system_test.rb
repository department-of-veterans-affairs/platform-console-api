# frozen_string_literal: true

require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'log in success' do
    visit '/login'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    assert page.has_content? 'Logged in successfully'
    assert_equal '/', current_path
  end

  test 'log in failure' do
    visit '/login'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'bad_password'
    click_button 'Log in'

    assert page.has_content? 'Invalid email or password'
    assert_equal '/login', current_path
  end
end
