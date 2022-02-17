# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test 'get home' do
    get :home
    assert_response :success
  end
end
