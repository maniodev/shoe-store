# frozen_string_literal: true

REDIS_POOL = ConnectionPool.new(size: 10) { Redis.new(url: ENV["REDIS_URL"]) }

Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL
end
