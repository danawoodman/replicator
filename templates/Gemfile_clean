source 'https://rubygems.org'

ruby '2.0.0'

gem 'airbrake', '~> 3.1'
# gem 'ancestry', '~> 2.0'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass', branch: '3'
gem 'cancan', '~> 1.6'
gem 'coffee-rails', '~> 4.0'
gem 'delayed_job_active_record', '~> 4.0'
gem 'devise', '~> 3.1'
gem 'email_validator', '~> 1.4'
gem 'figaro', '~> 0.7'
gem 'font-awesome-rails', '~> 3.2'
gem 'jquery-rails', '~> 3.0'
gem 'neat', '~> 1.4'
gem 'newrelic_rpm', '~> 3.6'
gem 'pg', '~> 0.17'
gem 'rack-timeout', '~> 0.0'
gem 'rails', '4.0.0'
gem 'recipient_interceptor', '~> 0.1'
gem 'rolify', '~> 3.2'
gem 'sass-rails', '~> 4.0'
gem 'slim', '~> 2.0'
# gem 'stripe', '~> 1.7'
gem 'tinymce-rails', '~> 4.0'
gem 'turbolinks', '~> 1.3'
gem 'uglifier', '~> 1.3'

group :development do
  gem 'better_errors', '~> 1.0'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :rbx]
  gem 'guard-bundler', '~> 1.0'
  gem 'guard-rails', '~> 0.4'
  gem 'guard-rspec', '~> 2.5'
  gem 'haml-rails', '~> 0.4'
  gem 'haml2slim', '~> 0.4'
  gem 'html2haml', '~> 1.0'
  gem 'hub', '~> 1.10', require: nil
  gem 'quiet_assets', '~> 1.0'
  gem 'rb-fchange', '~> 0.0', require: false
  gem 'rb-fsevent', '~> 0.9', require: false
  gem 'rb-inotify', '~> 0.9', require: false
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.2'
  gem 'guard-spork', '~> 1.5'
  gem 'guard-rspec', '~> 2.5'
  gem 'rspec-rails', '~> 2.14'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
end

group :staging, :production do
  gem 'rails_12factor', '~> 0.0' # heroku asset pipeline helper
  gem 'unicorn', '~> 4.6'
end

group :test do
  gem 'capybara', '~> 2.1'
  gem 'database_cleaner', '~> 1.0'
  gem 'email_spec', '~> 1.5'
  gem 'launchy', '~> 2.3'
  gem 'shoulda-matchers', '~> 2.4'
  gem 'simplecov', '~> 0.7', require: false
  gem 'timecop', '~> 0.6'
  gem 'webmock', '~> 1.13'
end
