source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4.2"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Added gems:

# See https://github.com/plataformatec/devise
gem 'devise' # (flexible authentication solution)

# See https://github.com/tigrish/devise-i18n
gem 'devise-i18n' # (devise locale data collection)

# See https://github.com/laserlemon/figaro
gem 'figaro' # (ENV file: config/application.yml)

# See http://haml.info
gem 'haml-rails' # (HAML)
#
# See https://github.com/iain/http_accept_language
gem 'http_accept_language'
#
# # See https://github.com/jnunemaker/httparty
# gem 'httparty'
#
# See https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 7.0.0' # (rails locale data collection)

# See https://github.com/ambethia/recaptcha
gem 'recaptcha'

# See https://github.com/mislav/will_paginate
gem 'will_paginate'

group :development do
  gem 'better_errors'
  gem 'brakeman' # https://github.com/presidentbeef/brakeman
  gem 'bullet' # https://github.com/flyerhzm/bullet
  gem 'rails_best_practices' # Run: rails_best_practices . (https://github.com/flyerhzm/rails_best_practices)
  gem 'rack-mini-profiler' # https://github.com/MiniProfiler/rack-mini-profiler
end

group :test do
  gem 'factory_bot_rails' # https://github.com/thoughtbot/factory_bot
  gem 'factory_trace' # https://github.com/djezzzl/factory_trace
end

# See https://github.com/rspec/rspec-rails
group :development, :test do
  gem 'rspec-rails', '~> 6.1.1'
end
