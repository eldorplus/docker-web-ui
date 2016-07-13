require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'
require 'docker'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DockerAutomation
  class Application < Rails::Application

    docker_url = ENV['DOCKER_HOST']
    if !docker_url.to_s.empty?
        Docker.url = docker_url
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.time_zone = 'Pacific Time (US & Canada)'
    config.i18n.default_locale = :fr
    config.i18n.fallbacks = true

    config.autoload_paths += %W(#{config.root}/app/lib)

    config.active_record.raise_in_transactional_callbacks = true

    config.active_support.deprecation = :notify
    config.log_level = :info
    config.log_formatter = ::Logger::Formatter.new
    config.autoflush_log = true

    config.serve_static_assets = true
    config.assets.css_compressor = :yui
    config.assets.js_compressor = :uglifier
    config.assets.compile = true
    config.assets.digest = true
    config.assets.version = '1.0'
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.precompile += %w(.svg .eot .woff .ttf)
    config.stylesheets_dir = '/css'
    config.action_controller.session_store = :active_record_store

    # Docker Automation API
    config.x.api_url = 'http://0.0.0.0:80/v1'

    # Docker config
    config.x.docker_url = 'tcp://192.168.65.25:5422'
  end
end
