class SiteController < DeviseController
  helper 'site'
  layout 'site'

  def index
    #@account = Account.all
  end

  def account
    render :text => 'show me'
  end
end