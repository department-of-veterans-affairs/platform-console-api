# frozen_string_literal: true

require 'application_system_test_case'

class PageTest < ApplicationSystemTestCase
  test 'home page loads' do
    visit '/'
    assert_equal current_path, '/'
    assert page.has_content? 'Welcome to the Platform'
  end
end
