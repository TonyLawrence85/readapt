source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 8.0.2"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Security floors for dependencies flagged by bundler-audit.
gem "nokogiri", ">= 1.19.4"
gem "rails-html-sanitizer", ">= 1.7.1"
gem "websocket-driver", ">= 0.8.2"
gem "net-imap", ">= 0.6.4.1"
gem "crass", ">= 1.0.7"
gem "faraday", ">= 2.14.3"
gem "json", ">= 2.19.9"
gem "jwt", ">= 3.2.0"
gem "mail", ">= 2.9.1"
gem "msgpack", ">= 1.8.2"
gem "concurrent-ruby", ">= 1.3.7"

# Use Active Model has_secure_password
# https://guides.rubyonrails.org/active_model_basics.html#securepassword
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma
# https://github.com/basecamp/thruster/
gem "thruster", require: false

# Use Active Storage variants
# https://guides.rubyonrails.org/active_storage_overview.html#transforming-images
gem "image_processing", "~> 1.2"

gem "sprockets-rails"
gem "bootstrap", "~> 5.3"
gem "devise", ">= 5.0.4"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem "ruby_llm", "~> 1.2.0"
gem "pdf-reader"
gem "text-hyphen"
gem "cloudinary"
gem "ruby-openai"
group :development, :test do
  gem "dotenv-rails"
  # See the Rails debugging guide for details about the debug gem.
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", ">= 8.0.6", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages; see the Rails debugging guide.
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "google-cloud-text_to_speech"
