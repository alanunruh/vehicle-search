require 'sidekiq'

redis_url = ENV['REDIS_URL']
config_hash = { url: redis_url }

Sidekiq.configure_server do |config|
  config.redis = config_hash
end

Sidekiq.configure_client do |config|
  config.redis = config_hash
end
