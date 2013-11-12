class Authentications < RestApi::Base
  allow_anonymous

  schema do
    attribute :user_id, :string
    attribute :provider, :string
    attribute :uid, :string
  end

  belongs_to :account
end