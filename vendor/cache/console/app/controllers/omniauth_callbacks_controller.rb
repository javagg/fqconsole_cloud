class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Callback methods
  Devise.omniauth_providers.each do |provider|
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def #{provider}
        oauth_for("#{provider}")
      end
    EOS
  end

  private

  # This method is just for the convenience of testing
  def oauth_for(provider)
    #unless account_signed_in?
    omniauth = request.env["omniauth.auth"]
    if authentication = Authentications.find(:first, params: { provider: provider, uid: omniauth[:uid] })
      sign_in_and_redirect(:account, authentication.account)
    elsif
      account = find_or_create_new_omniauth_user(omniauth)
      # Create a new User through omniauth
      flash[:notice] = t(:signed_in_successfully)
      sign_in_and_redirect(:account, account)
    elsif
      # New user data not valid, try again
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_account_registration_path
    end

    @account = Account.send("find_for_#{provider}_oauth", request.env["omniauth.auth"], current_account)
    if @account.persisted?
      sign_in_and_redirect @account, :event => :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_account_registration_path
    end
  end

  def find_or_create_new_omniauth_user(omniauth)
    email = omniauth[:email]
    if email
      account = Account.find(:first, params: { })
    else
      account = Account.new
    end

    account.apply_omniauth(omniauth)
    if account.save
      account
    else
      nil
    end
  end
end