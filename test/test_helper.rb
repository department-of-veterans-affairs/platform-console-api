# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_filter 'lib/templates'
    add_filter 'lib/dotenv'
    coverage_dir 'public/coverage'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data('github_token') { ENV['GITHUB_ACCESS_TOKEN'] }
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def login_as(user)
      visit "/login?uid=#{users(user).uid}"
    end
  end
end

# FIXME: Remove when fixed
# https://github.com/vcr/vcr/pull/907/files
module VCR
  class LibraryHooks
    # @private
    module WebMock
      module_function

      def with_global_hook_disabled(request)
        global_hook_disabled_requests << request

        begin
          yield
        ensure
          global_hook_disabled_requests.delete(request)
        end
      end

      def global_hook_disabled?(request)
        requests = Thread.current[:_vcr_webmock_disabled_requests]
        requests&.include?(request)
      end

      def global_hook_disabled_requests
        Thread.current[:_vcr_webmock_disabled_requests] ||= []
      end
    end
  end
end
