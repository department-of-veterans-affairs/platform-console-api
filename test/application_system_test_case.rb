# frozen_string_literal: true

require 'test_helper'

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end
