source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Core Rails gems
gem 'rails', '~> 7.1.0'
gem 'pg', '~> 1.1' # PostgreSQL
gem 'puma', '~> 6.0' # App server
gem 'sass-rails', '>= 6' # CSS processing
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7' # JSON API
gem 'bootsnap', '>= 1.4.4', require: false

# Authentication & Authorization
gem 'devise'
gem 'cancancan'

# Search functionality
gem 'ransack'

# Environment variables
gem 'dotenv-rails', groups: [:development, :test]

# Development group
group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'

  # Linting
  gem 'rubocop', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
end

# Development and test group
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rswag'
end

# Platform specific
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]