class Account < RestApi::Base
  devise :rest_authenticatable, :registerable, :omniauthable, :recoverable, :timeoutable, :validatable

  allow_anonymous

  schema do
    string :username
    string :password
  end

  # NOTE: Devise need email somehow
  alias_attribute :email, :username

  has_many :authentications

  attr_accessible  :password_confirmation, :remember_me

  Devise.omniauth_providers.each do |provider|
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def self.find_for_#{provider}_oauth(auth, signed_in_resource = nil)
        account = self.find(:first, params: { provider: auth.provider, uid: auth.uid })
        unless account
          account = self.create(name:auth.extra.raw_info.name, provider:auth.provider,
             uid:auth.uid,email:auth.info.email, password:Devise.friendly_token[0,20])
        end
        account
      end
    EOS
  end

  def self.find_or_create_for_oauth(auth)
    account = self.find(:first, params: { provider: auth.provider, uid: auth.uid })
    unless account
      account = self.create(name:auth.extra.raw_info.name, provider:auth.provider,
                            uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20])
    end
    account
  end

  # Devise need this method return an array containing at least two elements
  def self.serialize_into_session(account)
    [account.username, account.password]
  end

  def self.serialize_from_session(*args)
    username = args[0]
    password = args[1]
    to_adapter.find_first(username: username, password: password)
  end

  # fetch attributes from the omniauth-record.
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def apply_trusted_services(omniauth)

    # Merge user_info && extra.user_info
    #user_info = omniauth['user_info']
    #if omniauth['extra'] && omniauth['extra']['user_hash']
    #  user_info.merge!(omniauth['extra']['user_hash'])
    #end

    # try name or nickname
    #if self.name.blank?
    #  self.name = user_info['name'] unless user_info['name'].blank?
    #  self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
    #  self.name ||= (user_info['first_name']+" "+user_info['last_name']) unless \
    #    user_info['first_name'].blank? || user_info['last_name'].blank?
    #end

    #if self.email.blank?
    #  self.email = user_info['email'] unless user_info['email'].blank?
    #end

    # Set a random password for omniauthenticated users
    self.password, self.password_confirmation = String::random_string(10)
    #self.confirmed_at, self.confirmation_sent_at = Time.now

    # Build a new Authentication and remember until :after_create -> save_new_authentication
    #@new_auth = authentications.build(uid: omniauth['uid'], provider: omniauth['provider'])
  end
end
