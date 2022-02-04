# frozen_string_literal: true

rails_root = Rails.root || "#{File.dirname(__FILE__)}/../.."
rails_env = Rails.env || 'development'
redis_config = YAML.load_file("#{rails_root}/config/redis.yml")
redis_config.merge! redis_config.fetch(rails_env, {})
redis_config.symbolize_keys!

Sidekiq.configure_server do |config|
  config.redis = { url: "#{redis_config[:url]}/#{redis_config[:db]}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{redis_config[:url]}/#{redis_config[:db]}" }
end
