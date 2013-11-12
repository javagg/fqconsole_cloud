require 'devise/strategies/base'

module Devise
  module Strategies
    class RestAuthenticatable < Authenticatable
      def valid?
        valid_for_rest_auth?
      end

      def authenticate!
        authentication_hash = params[scope] || {}
        resource = mapping.to.find_for_rest_authentication(authentication_hash)
        return fail(:invalid_token) unless resource

        if validate(resource)
          resource.after_rest_authentication
          success!(resource)
        end
      end

      private

      # TODO:
      def validate(resource, &block)
        super(resource, &block)
      end

      def valid_for_rest_auth?
        true
      end
    end
  end
end

Warden::Strategies.add(:rest_authenticatable, Devise::Strategies::RestAuthenticatable)
