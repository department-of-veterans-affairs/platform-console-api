# frozen_string_literal: true

Datadog.configure do |c|
  c.use :rails
  c.service = 'platform-console-api'
  c.tracer.enabled = true
  c.tracer hostname: 'datadog-agent',
           port: 8126
end
