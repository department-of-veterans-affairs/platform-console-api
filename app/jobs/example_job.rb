# frozen_string_literal: true

# Just a lowly example job that will be deleted soon.
class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
