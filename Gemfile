source 'http://rubygems.org'

# Fedora 19 splits psych out into its own gem.
if Gem::Specification.respond_to?(:find_all_by_name) and not Gem::Specification::find_all_by_name('psych').empty?
  gem 'psych'
end

# Order matters!!!
gem 'devise', '2.2.7'
gem 'openshift-origin-console', :require => 'console', :path => 'vendor/gems/origin/console'
if ENV["FQ_SERVER_SRC"]
  gem 'openshift-freequant-console', :require => 'openshift_freequant_console', :path => File.join(ENV["FQ_SERVER_SRC"], 'console')
else
  gem 'openshift-freequant-console', :require => 'openshift_freequant_console', :path => 'vendor/gems/freequant/console'
end

gem 'rake', '> 0.9.2'
gem 'pry', :require => 'pry' if ENV['PRY']
gem 'perftools.rb', :require => 'perftools' if ENV['PERFTOOLS']

# NON-RUNTIME BEGIN

# To simplify the packaging burden for distro maintainers it's important to
# place all gems not needed at runtime in this section.  It can be removed
# during package build time to avoid having to ship/support development-only
# packages.
group :test do
  gem 'ci_reporter',   '>= 1.7.0', :require => false
  gem 'minitest',      '>= 3.5.0', :require => false
end

# NON-RUNTIME END

group :assets do
  gem 'compass-rails', '~> 1.0.3'
  gem 'sass-rails',    '~> 3.2.5'
  gem 'coffee-rails',  '~> 3.2.2'
  gem 'jquery-rails',  '~> 2.0.2'
  gem 'uglifier',      '>= 1.2.6'
#  gem 'therubyracer',  '>= 0.10'
  gem 'sass-twitter-bootstrap', '2.0.1'
  gem 'minitest',      '>= 3.5.0'
end

gem 'thin'

gem 'omniauth-oauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
gem 'rack-proxy', '0.5.8'
gem 'faye-websocket', '0.4.7'

group :assets do
  gem 'bootstrap-sass-rails', '3.0.2.1'
  gem 'font-awesome-rails', '4.0.3.0'
end