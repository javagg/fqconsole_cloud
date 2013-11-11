module Devise
  module Models
    module RestAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :password_confirmation
      end

      def authentication_keys
        [:password]
        #@authentication_keys ||= [mapping.to.token_authentication_key]
      end

      # Verifies whether an password (ie from sign in) is the user password.
      def valid_password?(password)
        true
      end

      # Set password and password confirmation to nil
      def clean_up_passwords
        self.password = self.password_confirmation = nil
      end

      # Update record attributes when :current_password matches, otherwise returns
      # error on :current_password. It also automatically rejects :password and
      # :password_confirmation if they are blank.
      def update_with_password(params, *options)
        current_password = params.delete(:current_password)

        if params[:password].blank?
          params.delete(:password)
          params.delete(:password_confirmation) if params[:password_confirmation].blank?
        end

        result = if valid_password?(current_password)
                   update_attributes(params, *options)
                 else
                   self.assign_attributes(params, *options)
                   self.valid?
                   self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
                   false
                 end

        clean_up_passwords
        result
      end

      # Updates record attributes without asking for the current password.
      # Never allows a change to the current password. If you are using this
      # method, you should probably override this method to protect other
      # attributes you would not like to be updated without a password.
      #
      # Example:
      #
      #   def update_without_password(params={})
      #     params.delete(:email)
      #     super(params)
      #   end
      #
      def update_without_password(params, *options)
        params.delete(:password)
        params.delete(:password_confirmation)

        result = update_attributes(params, *options)
        clean_up_passwords
        result
      end

      # Destroy record when :current_password matches, otherwise returns
      # error on :current_password. It also automatically rejects
      # :current_password if it is blank.
      def destroy_with_password(current_password)
        result = if valid_password?(current_password)
                   destroy
                 else
                   self.valid?
                   self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
                   false
                 end

        result
      end

      def after_rest_authentication
      end

      protected
      module ClassMethods
        def find_for_rest_authentication(conditions)
          # FIXME: shouldn't give empty hash
          #conditions = {} if conditions.nil?
          find_for_authentication(conditions)
        end
      end
    end
  end
end
