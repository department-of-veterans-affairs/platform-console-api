# frozen_string_literal: true

Datadog.configure do |c|
  c.use :rails
  c.service = 'platform-console-api'
  c.tracer.enabled = Rails.env.production?
  c.tracer hostname: 'datadog-agent',
           port: 8126
end
