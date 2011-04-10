# Don't change this file!
# Configure your app in config/environment.rb and config/environments/*.rb

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

module Rails
  class << self
    def boot!
      unless booted?
        preinitialize
        pick_boot.run
      end
    end

    def booted?
      defined? Rails::Initializer
    end

    def pick_boot
      (vendor_rails? ? VendorBoot : GemBoot).new
    end

    def vendor_rails?
      File.exist?("#{RAILS_ROOT}/vendor/rails")
    end

    def preinitialize
      load(preinitializer_path) if File.exist?(preinitializer_path)
    end

    def preinitializer_path
      "#{RAILS_ROOT}/config/preinitializer.rb"
    end
  end

  class Boot
    def run
      load_initializer
      Rails::Initializer.run(:set_load_path)
    end
  end

  class VendorBoot < Boot
    def load_initializer
      require "#{RAILS_ROOT}/vendor/rails/railties/lib/initializer"
      Rails::Initializer.run(:install_gem_spec_stubs)
      Rails::GemDependency.add_frozen_gem_path
    end
  end

  class GemBoot < Boot
    def load_initializer
      self.class.load_rubygems
      load_rails_gem
      require 'initializer'
    end

    def load_rails_gem
      if version = self.class.gem_version
        gem 'rails', version
      else
        gem 'rails'
      end
    rescue Gem::LoadError => load_error
      if load_error.message =~ /Could not find RubyGem rails/
        STDERR.puts %(Missing the Rails #{version} gem. Please `gem install -v=#{version} rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.)
        exit 1
      else
        raise
      end
    end

    class << self
      def rubygems_version
        Gem::RubyGemsVersion rescue nil
      end

      def gem_version
        if defined? RAILS_GEM_VERSION
          RAILS_GEM_VERSION
        elsif ENV.include?('RAILS_GEM_VERSION')
          ENV['RAILS_GEM_VERSION']
        else
          parse_gem_version(read_environment_rb)
        end
      end

      def load_rubygems
        min_version = '1.3.2'
        require 'rubygems'
        unless rubygems_version >= min_version
          $stderr.puts %Q(Rails requires RubyGems >= #{min_version} (you have #{rubygems_version}). Please `gem update --system` and try again.)
          exit 1
        end

      rescue LoadError
        $stderr.puts %Q(Rails requires RubyGems >= #{min_version}. Please install RubyGems and try again: http://rubygems.rubyforge.org)
        exit 1
      end

      def parse_gem_version(text)
        $1 if text =~ /^[^#]*RAILS_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
      end

      private
        def read_environment_rb
          File.read("#{RAILS_ROOT}/config/environment.rb")
        end
    end
  end
end

class Rails::Boot
  def run
    load_initializer

    Rails::Initializer.class_eval do
      def load_gems
        @bundler_loaded ||= Bundler.require :default, Rails.env
      end
    end

    Rails::Initializer.run(:set_load_path)
  end
end


# All that for this:
Rails.boot!
project_type = :rails
project_path = Compass::AppIntegration::Rails.root
environment = Compass::AppIntegration::Rails.env
http_path = "/"
css_dir = "tmp/stylesheets"
sass_dir = "app/stylesheets"

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
# An example database configuration file. Copy to database.yml.

development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
  
test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

# Heroku generates database.yml for staging and production.RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Do not declare gems here! We're using bundler. See Gemfile.

  config.autoload_paths += %W( #{RAILS_ROOT}/app/sweepers #{RAILS_ROOT}/app/mailers )

  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.time_zone = 'UTC'

end

Haml::Template.options[:attr_wrapper] = '"'
# heroku_san configuration, for easy multi-env deployments to heroku.
# Otherwise you've got to append --app appname all the fucking time.
#
# Format:
# 
# <heroku_san shorthand name>:
#   app: <Heroku app name>
#   config:
#     - <Heroku config:var name>: <Heroku config:var value>

production: 
  app: evening-sky-672
  config:
    BUNDLE_WITHOUT: "development:test"

staging:
  app: severe-autumn-903
  config: &default
   BUNDLE_WITHOUT: "development:test"
begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old for Rails 2.3." +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end
ActionController::Routing::Routes.draw do |map|

  map.root :controller => "application", :action => "show"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  
  map.register 'register', :controller => 'users', :action => 'new'
  map.resources :users, :only => [:new, :create]

  map.namespace :admin do |admin|
    admin.resources :roles
    admin.resources :users
    admin.root :controller => 'admin', :action => 'index'
  end

  map.namespace :members do |members|
    members.resources :users, :only => [:show, :edit, :update]
    members.root :controller => 'members', :action => 'index'
  end

end
