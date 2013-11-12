module Console::Auth::Devise
  extend ActiveSupport::Concern

  include Devise::Controllers::Helpers
  include Devise::Controllers::UrlHelpers

  class DeviseUser < RestApi::Credentials
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    def initialize(options = {})
      options.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def email_address
      nil
    end

    def persisted?
      false
    end
  end

  included do
    helper_method :current_user, :user_signed_in?, :previously_signed_in?
    rescue_from ActiveResource::UnauthorizedAccess, :with => :console_access_denied
  end

  # return the current authenticated user or nil
  def current_user
    @authenticated_user
  end

  def user_signed_in?
    not current_user.nil?
  end

  # This method should test authentication and handle if the user
  # is unauthenticated
  def authenticate_user!
    @authenticated_user ||= begin
      if account_signed_in? && current_account.username.present?
        DeviseUser.new(login: current_account.username, password: current_account.password)
      else
        console_access_denied
      end
    end
  end

  def previously_signed_in?
    cookies[:prev_login] ? true : false
  end

  protected

  def console_access_denied
    redirect_to new_account_session_path
  end
end
