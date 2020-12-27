# frozen_string_literal: true

sidekiq_config = { url: "redis://redis:#{ENV['REDIS_PORT']}/0" }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

# Sidekiq::Queue.new("chart").clear
# Sidekiq::RetrySet.new.clear
# Sidekiq::ScheduledSet.new.clear
