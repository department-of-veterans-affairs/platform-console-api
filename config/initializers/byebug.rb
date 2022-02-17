# frozen_string_literal: true

# Setup remote debugging for use in foreman
# See: https://github.com/deivid-rodriguez/byebug/blob/master/GUIDE.md#debugging-remote-programs
# Start remote server using byebug -R localhost:8989 after foreman has been started
if Rails.env.development?
  require 'byebug/core'
  begin
    Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
  rescue Errno::EADDRINUSE
    Rails.logger.debug 'Byebug server already running'
  end
end
