# frozen_string_literal: true

redis_config = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }

Sidekiq.configure_server do |config|
  config.redis = redis_config

  schedule_file = Rails.root.join('config/schedule.yml')
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file)) if schedule_file.exist?
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
