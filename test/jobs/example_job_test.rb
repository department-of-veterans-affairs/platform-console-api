# frozen_string_literal: true

require 'test_helper'

class ExampleJobTest < ActiveJob::TestCase
  test 'the truth' do
    ExampleJob.perform_now
    assert true
  end
end
