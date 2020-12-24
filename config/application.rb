require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PokemonEventSourced
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.eager_load_paths << "#{Rails.root}/lib"
    if Rails.env.development?
      config.autoload_paths += Dir.glob("#{config.root}/lib_development")
      config.autoload_paths += Dir.glob("#{config.root}/lib_development/generators/*")
    end
  end
end
