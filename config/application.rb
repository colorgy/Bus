require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bus
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.paths.add File.join('app', 'services'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*')]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 8

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :"zh-TW"
    config.i18n.locale = :"zh-TW"

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # assets pipeline config to work on Heroku
    config.assets.initialize_on_precompile = false

    # add active admin assets to precompile list, loaded from vendor/assets
    config.assets.precompile += %w( active_admin.js active_admin.css.scss )

    # config sidekiq for active job
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.default_url_options = { host: ENV['APP_URL'] }

    case ENV['LOGGER']
    when 'stdout'
      require 'rails_stdout_logging/rails'
      config.logger = RailsStdoutLogging::Rails.heroku_stdout_logger
    when 'remote'
      # Send logs to a remote server
      if !ENV['REMOTE_LOGGER_HOST'].blank? && !ENV['REMOTE_LOGGER_PORT'].blank?
        app_name = ENV['APP_NAME'] || Rails.application.class.parent_name
        config.logger = \
          RemoteSyslogLogger.new(ENV['REMOTE_LOGGER_HOST'], ENV['REMOTE_LOGGER_PORT'],
                                 local_hostname: "#{app_name.underscore}-core-#{Socket.gethostname}".gsub(' ', '_'),
                                 program: ('rails-' + Rails.application.class.parent_name.underscore))
      end
    end
  end
end
