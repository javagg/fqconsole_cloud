class StrategiesController < DeviseBaseController
  include DomainAware
  include Console::CommunityAware

  def index
    user_default_domain rescue nil
    return redirect_to application_types_path, :notice => 'Create your first application now!' if @domain.nil? || @domain.applications.empty?
    @applications_filter = ApplicationsFilter.new params[:applications_filter]
    @applications = @applications_filter.apply(@domain.applications)
  end

  def create

  end

  def destroy

  end
end