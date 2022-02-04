# frozen_string_literal: true

rails_root = Rails.root || "#{File.dirname(__FILE__)}/../.."
rails_env = Rails.env || 'development'
redis_config = YAML.load_file("#{rails_root}/config/redis.yml")
redis_config.merge! redis_config.fetch(rails_env, {})
redis_config.symbolize_keys!

Redis.current = Redis.new(url: "#{redis_config[:url]}/#{redis_config[:db]}")
