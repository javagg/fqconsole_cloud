require 'rubygems'

unless ENV["RAILS_ENV"] == "test"
  if File.exist?('/etc/openshift/development')
    ENV["RAILS_ENV"] = "development"
  else
    ENV["RAILS_ENV"] = "production"
  end
end

ENV['RAILS_LOG_PATH'] = "log/#{ENV["RAILS_ENV"]}.log"
ENV['CONSOLE_CONFIG_FILE'] = 'etc/openshift/console.conf'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
