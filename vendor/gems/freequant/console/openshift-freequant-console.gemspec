# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-freequant-console"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Lee"]
  s.date = "2013-11-29"
  s.description = "The OpenShift Freequant console is a Rails engine that provides an easy-to-use interface for managing OpenShift Freequant applications."
  s.email = ["lu.lee05@gmail.com"]
  s.files = ["Gemfile", "LICENSE", "COPYRIGHT", "README.md", "Rakefile", "app/helpers/site_helper.rb", "app/helpers/console/console_helper.rb", "app/controllers/application_types_controller.rb", "app/controllers/strategies_controller.rb", "app/controllers/password_controller.rb", "app/controllers/console_controller.rb", "app/controllers/site_controller.rb", "app/controllers/omniauth_callbacks_controller.rb", "app/controllers/console_base_controller.rb", "app/controllers/authentications_controller.rb", "app/controllers/console/auth/devise.rb", "app/controllers/editing_controller.rb", "app/controllers/strategy_types_controller.rb", "app/controllers/devise_base_controller.rb", "app/assets/stylesheets/freequant.css.scss", "app/assets/stylesheets/freequant_console.scss", "app/assets/javascripts/freequant_console.js", "app/middlewares/ide_proxy.rb", "app/middlewares/subdomain_ide_proxy.rb", "app/views/strategy_types/index.html.haml", "app/views/starts/_form.html.haml", "app/views/starts/show.html.haml", "app/views/layouts/application.html.haml", "app/views/layouts/simple.html.haml", "app/views/layouts/site.html.haml", "app/views/layouts/freequant/_header.html.haml", "app/views/layouts/site/_javascripts.html.haml", "app/views/layouts/site/_footer.html.haml", "app/views/layouts/site/_head.html.haml", "app/views/layouts/site/_stylesheets.html.haml", "app/views/layouts/site/_header.html.haml", "app/views/layouts/freequant.html.haml", "app/views/authentications/index.html.haml", "app/views/authentications/_authentication.haml", "app/views/authentications/_authentications.haml", "app/views/strategies/index.html.haml", "app/views/strategies/_application2.html.haml", "app/views/strategies/show.html.haml", "app/views/password/edit.html.haml", "app/views/password/new.html.haml", "app/views/devise/sessions/new.html.haml", "app/views/devise/registrations/edit.html.haml", "app/views/devise/registrations/new.html.haml", "app/views/stops/_form.html.haml", "app/views/stops/show.html.haml", "app/views/site/index.html.haml", "app/models/account.rb", "app/models/application.rb", "app/models/capabilities.rb", "app/models/authentications.rb", "config/initializers/freequant_console.rb", "config/initializers/devise.rb", "config/initializers/faye-websocket.rb", "config/initializers/console.rb", "config/locales/en.yml", "config/locales/zh-CN.yml", "config/routes.rb", "lib/openshift_freequant_console.rb", "lib/omniauth/strategies/weibo.rb", "lib/omniauth/strategies/bitbucket.rb", "lib/omniauth/strategies/qq.rb", "lib/devise/strategies/rest_authenticatable.rb", "lib/devise/models/rest_authenticatable.rb", "lib/devise/orm/rest_api.rb", "lib/rack/ws_proxy.rb", "lib/openshift_freequant_console/engine.rb", "lib/openshift_freequant_console/version.rb", "lib/openshift_freequant_console/rails/routes.rb", "lib/orm_adapter/adapters/rest_api.rb", "test/test_helper.rb", "test/fixtures/quickstarts.csv", "test/fixtures/cert.crt", "test/fixtures/cartridges.json", "test/fixtures/cert_key_rsa", "test/bin/server.rb", "test/bin/test_ide_proxy.rb", "test/bin/test_ws_proxy.rb", "test/bin/client.rb", "test/coverage_helper.rb", "test/support/auth.rb", "test/support/base.rb", "test/support/garbage_collection.rb", "test/support/capybara.rb", "test/support/rest_api.rb", "test/support/errors.rb", "test/rails_app/script/rails", "test/rails_app/app/controllers/application_controller.rb", "test/rails_app/config.ru", "test/rails_app/conf/console.conf", "test/rails_app/public/favicon.ico", "test/rails_app/config/environment.rb", "test/rails_app/config/environments/test.rb", "test/rails_app/config/environments/production.rb", "test/rails_app/config/environments/development.rb", "test/rails_app/config/initializers/session_store.rb", "test/rails_app/config/initializers/inflections.rb", "test/rails_app/config/initializers/secret_token.rb", "test/rails_app/config/initializers/backtrace_silencers.rb", "test/rails_app/config/initializers/mime_types.rb", "test/rails_app/config/application.rb", "test/rails_app/config/locales/en.yml", "test/rails_app/config/boot.rb", "test/rails_app/Rakefile", "test/rails_app/log/production.log", "test/rails_app/log/development.log", "test/models/rest_authenticatable_test.rb"]
  s.homepage = "https://github.com/openshift/origin-server/tree/master/console"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.13"
  s.summary = "OpenShift Freequant Management Console"
  s.test_files = ["test/test_helper.rb", "test/fixtures/quickstarts.csv", "test/fixtures/cert.crt", "test/fixtures/cartridges.json", "test/fixtures/cert_key_rsa", "test/bin/server.rb", "test/bin/test_ide_proxy.rb", "test/bin/test_ws_proxy.rb", "test/bin/client.rb", "test/coverage_helper.rb", "test/support/auth.rb", "test/support/base.rb", "test/support/garbage_collection.rb", "test/support/capybara.rb", "test/support/rest_api.rb", "test/support/errors.rb", "test/rails_app/script/rails", "test/rails_app/app/controllers/application_controller.rb", "test/rails_app/config.ru", "test/rails_app/conf/console.conf", "test/rails_app/public/favicon.ico", "test/rails_app/config/environment.rb", "test/rails_app/config/environments/test.rb", "test/rails_app/config/environments/production.rb", "test/rails_app/config/environments/development.rb", "test/rails_app/config/initializers/session_store.rb", "test/rails_app/config/initializers/inflections.rb", "test/rails_app/config/initializers/secret_token.rb", "test/rails_app/config/initializers/backtrace_silencers.rb", "test/rails_app/config/initializers/mime_types.rb", "test/rails_app/config/application.rb", "test/rails_app/config/locales/en.yml", "test/rails_app/config/boot.rb", "test/rails_app/Rakefile", "test/rails_app/log/production.log", "test/rails_app/log/development.log", "test/models/rest_authenticatable_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<openshift-origin-console>, [">= 0"])
      s.add_runtime_dependency(%q<devise>, ["= 3.2.2"])
      s.add_runtime_dependency(%q<omniauth>, ["= 1.1.4"])
      s.add_runtime_dependency(%q<omniauth-oauth>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["= 1.1.1"])
    else
      s.add_dependency(%q<openshift-origin-console>, [">= 0"])
      s.add_dependency(%q<devise>, ["= 3.2.2"])
      s.add_dependency(%q<omniauth>, ["= 1.1.4"])
      s.add_dependency(%q<omniauth-oauth>, ["= 1.0.1"])
      s.add_dependency(%q<omniauth-oauth2>, ["= 1.1.1"])
    end
  else
    s.add_dependency(%q<openshift-origin-console>, [">= 0"])
    s.add_dependency(%q<devise>, ["= 3.2.2"])
    s.add_dependency(%q<omniauth>, ["= 1.1.4"])
    s.add_dependency(%q<omniauth-oauth>, ["= 1.0.1"])
    s.add_dependency(%q<omniauth-oauth2>, ["= 1.1.1"])
  end
end

