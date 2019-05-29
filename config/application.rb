require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sehatq
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.middleware.use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :post, :put, :delete, :patch, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.session_store :cookie_store, key: '_interslice_session'
    # config.middleware.use ActionDispatch::Cookies # Required for all session management
    # config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    config.time_zone = 'Jakarta'
    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.eager_load_paths += %W(#{config.root}/lib)
    config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.assets.paths << Rails.root.join("vendor", "assets", "stylesheets")
    config.assets.paths << Rails.root.join("vendor", "assets", "javascripts")
    config.assets.initialize_on_precompile = true
    config.action_dispatch.ignore_accept_header = true
    config.quiet_assets = true
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL',
        'Vary' => 'Accept-Encoding'
    }

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
  end
end
