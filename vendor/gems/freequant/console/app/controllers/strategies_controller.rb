class StrategiesController < ConsoleController
  include AsyncAware
  include Console::ModelHelper

  # trigger synchronous module load
  [GearGroup, Cartridge, Key, Application] if Rails.env.development?

  def index
    async { @applications = Application.find :all, :as => current_user, :params => {:include => :cartridges} }
    async { @domains = user_domains }
    join(10)

    render :first_steps and return if @applications.blank?

    @has_key = sshkey_uploaded?
    @user_owned_domains = user_owned_domains
    @empty_owned_domains = @user_owned_domains.select { |d| d.application_count == 0 }
    @empty_unowned_domains = @domains.select { |d| !d.owner? && d.application_count == 0 }
    @capabilities = user_capabilities
  end

  def show
    @capabilities = user_capabilities

    app_id = params[:id].to_s

    async { @application = Application.find(app_id, :as => current_user, :params => {:include => :cartridges}) }
    async { @gear_groups_with_state = GearGroup.all(:as => current_user, :params => {:application_id => app_id, :timeout => 3}) }
    async { sshkey_uploaded? }

    join!(30)

    @gear_groups = @application.cartridge_gear_groups
    @gear_groups.each{ |g| g.merge_gears(@gear_groups_with_state) }
  end
end