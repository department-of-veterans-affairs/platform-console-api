# frozen_string_literal: true

# TODO: revomve this file once this merge has been released https://github.com/vcr/vcr/pull/907/files

# Overrides for fixing issues caused by ruby 3.1
module VcrWebmocxExtensions
  def global_hook_disabled?(request)
    requests = Thread.current[:_vcr_webmock_disabled_requests]
    requests&.include?(request)
  end

  def global_hook_disabled_requests
    Thread.current[:_vcr_webmock_disabled_requests] ||= []
  end
end
