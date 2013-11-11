# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController

  def index
    @authentications = current_account.authentications if current_account
  end

  # Create an authentication when this is called from
  # the authentication provider callback.
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication
      # Just sign in an existing user with omniauth
      flash[:notice] = t(:signed_in_successfully)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_account
      # Add authentication to signed in user
      current_account.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:authentication_successful)
      redirect_to authentications_url
    elsif user = create_new_omniauth_user(omniauth)
      # Create a new User through omniauth
      flash[:notice] = t(:signed_in_successfully)
      sign_in_and_redirect(:user, user)
    else
      # New user data not valid, try again
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_account_registration_url
    end
  end

  # destroy user's authentication and return to the authentication page.
  def destroy
    @authentication = current_account.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t(:successfully_destroyed_authentication)
    redirect_to authentications_url
  end

  # try again when authentication failed.
  def auth_failure
    redirect_to '/users/sign_in', :alert => params[:message]
  end

  private

  def create_authentication(omniauth)
    Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
  end

  # Create a new user and assign an authentication to it.
  def create_new_omniauth_user(omniauth)
    user = Account.new
    user.apply_omniauth(omniauth)
    if user.save
      user
    else
      nil
    end
  end
end