require 'openshift_freequant_console/version'
require 'openshift_freequant_console/engine'

require 'devise'
require 'devise/models/rest_authenticatable'
require 'devise/strategies/rest_authenticatable'

Devise::add_module :rest_authenticatable, strategy: true, controller: :sessions, route: { session: [nil, :new, :destroy] }

require 'omniauth/strategies/bitbucket'
require 'omniauth/strategies/weibo'