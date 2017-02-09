require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpaBackend
  class Application < Rails::Application

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins Rails.application.secrets.cors_origin

        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :patch]
      end
    end

    config.active_record.raise_in_transactional_callbacks = true
  end
end
