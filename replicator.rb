require "rvm"
require "etc"

# global settings
DEVELOPMENT = true

# source_paths File.expand_path(File.dirname(__FILE__), "templates")

# helper methods
def say_something(text)
  say "\033[1m\033[36m#{text}\033[0m"
end

def ask_something(question)
  ask "\033[1m\033[36m#{question.rjust(10)}\033[0m"
end

def import_template(source, destination)
  if DEVELOPMENT
    template source, destination
  else
    get "https://github.com/teleporter/replicator/blob/master/templates/#{source}", destination
  end
end

# def yes_wizard?(question)
#   answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
#   case answer.downcase
#     when "yes", "y"
#       true
#     when "no", "n"
#       false
#     else
#       yes_wizard?(question)
#   end
# end

# def no_wizard?(question); !yes_wizard?(question) end

# ask some questions
use_mongo = false
if yes? "Do you want to use MongoDB instead of PostgreSQL? [y|N]"
  use_mongo = true
  say_something "Using MongoDB instead of PostgreSQL"
end

use_devise = false
if yes? "Do you want to use Devise for authentication? [y|N]"
  use_devise = true
  devise_model_name = ask_something "What would you like the user model to be called? [user]"
  devise_model_name = "user" if devise_model_name.blank?
end

# before installing gems, setup and use RVM
say_something "Creating .rvmrc file"
# RVM.gemset_create @app_name
current_rvm_version = run "rvm current"
create_file ".rvmrc", %Q(
if [[ -s "~/.rvm/environments/#{current_rvm_version}@#{@app_name}" ]] ; then
  . "~/.rvm/environments/ruby-1.9.3-p362@#{@app_name}"
else
  rvm --create use  "ruby-1.9.3-p362@#{@app_name}"
)
RVM.gemset_use! @app_name

# install gems
remove_file "Gemfile"
create_file "Gemfile"
add_source 'https://rubygems.org'
gem 'rails'
gem "slim"
gem "cancan"
gem "rolify"
gem "unicorn"
gem "rabl"
gem 'jquery-rails'

if use_mongo
  gem "mongoid"
else
  gem "pg"
end

if use_devise
  gem "devise"
end

gem_group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem "compass"
  gem "neat"
end

gem_group :development do
  gem "quiet_assets"
  gem "better_errors"
  gem "rb-inotify", require: false
  gem "rb-fsevent", require: false
  gem "rb-fchange", require: false
end

gem_group :test, :development do
  gem "rspec-rails"
  gem "guard-rspec"
  gem "guard-spork"
  gem "factory_girl_rails", require: false
end

gem_group :test do
  gem "database_cleaner"
  gem "capybara"
  gem "shoulda-matchers"
  gem "json_spec"
  gem "email_spec"
  if use_mongo
    gem "mongoid-rspec"
  end
end

# install all gems
run "bundle install"

# setup database configuration
# 
if use_mongo
  say_something "Creating mongoid.yml file"
  remove_file "config/database.yml"
  create_file "config/mongoid.yml", %Q(
development:
  # Configure available database sessions. (required)
  sessions:
    # Defines the default session. (required)
    default:
      # Defines the name of the default database that Mongoid can connect to.
      # (required).
      database: #{@appname}_development
      # Provides the hosts the default session can connect to. Must be an array
      # of host:port pairs. (required)
      hosts:
        - localhost:27017
      options:
        # Change whether the session persists in safe mode by default.
        # (default: false)
        # safe: false

        # Change the default consistency model to :eventual or :strong.
        # :eventual will send reads to secondaries, :strong sends everything
        # to master. (default: :eventual)
        # consistency: :eventual

        # How many times Moped should attempt to retry an operation after
        # failure. (default: 30)
        # max_retries: 30

        # The time in seconds that Moped should wait before retrying an
        # operation on failure. (default: 1)
        # retry_interval: 1
  # Configure Mongoid specific options. (optional)
  options:
    # Configuration for whether or not to allow access to fields that do
    # not have a field definition on the model. (default: true)
    # allow_dynamic_fields: true

    # Enable the identity map, needed for eager loading. (default: false)
    # identity_map_enabled: false

    # Includes the root model name in json serialization. (default: false)
    # include_root_in_json: false

    # Include the _type field in serializaion. (default: false)
    # include_type_for_serialization: false

    # Preload all models in development, needed when models use
    # inheritance. (default: false)
    # preload_models: false

    # Protect id and type from mass assignment. (default: true)
    # protect_sensitive_fields: true

    # Raise an error when performing a #find and the document is not found.
    # (default: true)
    # raise_not_found_error: true

    # Raise an error when defining a scope with the same name as an
    # existing method. (default: false)
    # scope_overwrite_exception: false

    # Skip the database version check, used when connecting to a db without
    # admin access. (default: false)
    # skip_version_check: false

    # User Active Support's time zone in conversions. (default: true)
    # use_activesupport_time_zone: true

    # Ensure all times are UTC in the app side. (default: false)
    # use_utc: false
test:
  sessions:
    default:
      database: #{@appname}_test
      hosts:
        - localhost:27017
      options:
        consistency: :strong
        # In the test environment we lower the retries and retry interval to
        # low amounts for fast failures.
        max_retries: 1
        retry_interval: 0
production:
  sessions:
    default:
      uri: <%= ENV['MONGOLAB_URI'] %>
      options:
        skip_version_check: true
        safe: true
)
else
  say_something "Creating database.yml file"
  remove_file "config/database.yml"
  create_file "config/database.yml", %Q(
development: &default
  adapter: postgresql
  encoding: unicode
  database: #{@appname}_development
  host: localhost
  pool: 5
  username: #{Etc.getlogin}
  password:

test:
  <<: *default
  database: #{@appname}_test
  min_messages: WARNING

production:
  <<: *default
  database: #{@appname}_production
)
  run "rake db:create:all"
end

if use_devise
  say_something "Setting up Devise"
  generate "devise:install"
  generate "devise", devise_model_name
  route %Q(
  devise_scope :#{devise_model_name} do
    get "login", :to => "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end
)
end

# initializers
initializer "rolify.rb", %Q(
Rolify.configure do |config|
  #{"config.use_mongoid" if use_mongo} 
  
  # Dynamic shortcuts for User class (user.is_admin? like methods). Default is: false
  # Enable this feature _after_ running rake db:migrate as it relies on the roles table
  # config.use_dynamic_shortcuts
end
)
initializer "rabl_config.rb", %Q(
Rabl.configure do |config|
  config.include_json_root = false
end
)

# setup test environment
generate "rspec:install"
run "spork rspec --bootstrap"

# stripe?


# use lvh.me as the domain for development and testing
application nil, env: [:development, :test] do
  %Q(
config.host = "lvh.me"
config.action_mailer.default_url_options = { :host => "lvh.me" }
)
end

# setup guard
# import_template "Guardfile", "Guardfile"
create_file "Guardfile", %Q(
guard "spork", :rspec_env => { "RAILS_ENV" => "test" } do
  watch("config/application.rb")
  watch("config/environment.rb")
  watch("config/environments/test.rb")
  watch(%r{^config/initializers/.+\.rb$})
  watch("Gemfile")
  watch("Gemfile.lock")
  watch(%r{^spec/support/(.+)\.rb$})
  watch("spec/spec_helper.rb") { :rspec }
  watch(%r{^factories/(.+)\.rb$}) { :rspec }
end

guard "rspec", :cli => "--drb --color -fd" do
  watch(%r{^spec/.+_spec\.rb$})
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^app/(.+)\.rb$}) { "spec" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$}) { "spec" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch("config/routes.rb") { "spec" }
end
)

# heroku setup
create_file "Procfile", "web: bundle exec unicorn -p $PORT -E $RACK_ENV"

# setup rspec
remove_file ".rspec"
create_file ".rspec", %Q(
--color
--format progress
--profile
)

# add license file

# setup static pages controller and routes
generate :controller, "static_pages home"
route "root to: \"static_pages#home\""
remove_file "public/index.html"

# cleanup
remove_file "README.rdoc"
create_file "README.md", %Q(
# #{@app_name}
)

if use_mongo
  # append_to_file "README.md" do
  #   "Make sure to set `MONGOLAB_URI` config variable if using Heroku"
  # end
end
remove_dir "test"

remove_file "app/assets/stylesheets/application.css", "app/assets/stylesheets/static_page.css.scss"
# TODO: Copy over default styles

# setup git
git :init
remove_file ".gitignore"
create_file ".gitignore", %Q(
# bundler state
/.bundle
/vendor/bundle/
/vendor/ruby/

# minimal Rails specific artifacts
db/*.sqlite3
/log/*
/tmp/*

# various artifacts
**.war
*.rbc
*.sassc
.rspec
.redcar/
.sass-cache
/config/config.yml
/config/database.yml
/coverage.data
/coverage/
/db/*.javadb/
/db/*.sqlite3
/doc/api/
/doc/app/
/doc/features.html
/doc/specs.html
/public/cache
/public/stylesheets/compiled
/public/system/*
/spec/tmp/*
/cache
/capybara*
/capybara-*.html
/gems
/specifications
rerun.txt
pickle-email-*.html

# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile ~/.gitignore_global
#
# Here are some files you may want to ignore globally:

# scm revert files
**.orig

# Mac finder artifacts
.DS_Store

# Netbeans project directory
/nbproject/

# RubyMine project files
.idea

# Textmate project files
/*.tmproj

# vim artifacts
**.swp

# Ignore application configuration
/config/application.yml

# Ignore Heroku environment file
.env
)
git add: ".", commit: "-m 'initial commit'"
