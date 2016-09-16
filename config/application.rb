require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.cache_store = :redis_store, ENV['CACHE_URL'],
                         { namespace: 'drkiq::cache' }
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.template_engine :slim
    end
  end
end
