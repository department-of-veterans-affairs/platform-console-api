# frozen_string_literal: true

Datadog.configure do |c|
  # Global settings
  c.agent.host = 'datadog-agent'
  c.agent.port = 8126
  c.service = 'platform-console-api'

  # Tracing settings
  c.tracing.enabled = Rails.env.production?

  # Instrumentation
  c.tracing.instrument :rails
end
