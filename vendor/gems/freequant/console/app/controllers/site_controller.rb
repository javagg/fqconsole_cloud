class SiteController < DeviseController
  helper 'site'
  layout 'site'

  include Console::CommunityAware

  def index
  end

  def account
    render :text => 'show me'
  end
end