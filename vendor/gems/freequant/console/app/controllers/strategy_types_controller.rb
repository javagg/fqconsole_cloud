class StrategyTypesController < ConsoleController
  include Console::ModelHelper
  include CostAware

  layout 'freequant'

  def index
    @capabilities = user_capabilities
    @browse_tags = [['Strategy', :strategy]]
    types = ApplicationType.tagged(@tag)
    @type_groups = [["Tagged with #{Array(@tag).to_sentence}", types.sort!]]
  end

  #def show
  #  app_params = params[:application] || params
  #  app_type_params = params[:application_type] || app_params
  #  @unlock_cartridges = to_boolean(params[:unlock])
  #
  #  @capabilities = user_capabilities :refresh => true
  #
  #  @user_writeable_domains = user_writeable_domains :refresh => true
  #  @user_default_domain = user_default_domain rescue (Domain.new)
  #  @can_create = @capabilities.max_domains > user_owned_domains.length
  #
  #  @gear_sizes = new_application_gear_sizes(@user_writeable_domains, @capabilities)
  #
  #  @compact = false # @domain.persisted?
  #
  #  @application_type = params[:id] == 'custom' ?
  #      ApplicationType.custom(app_type_params) :
  #      ApplicationType.find(params[:id])
  #
  #  @application = (@application_type >> Application.new(:as => current_user)).assign_attributes(app_params)
  #  @application.gear_profile = @gear_sizes.first unless @gear_sizes.include?(@application.gear_profile)
  #  @application.domain_name = app_params[:domain_name] || app_params[:domain_id] || @user_default_domain.name
  #
  #  (@domain_capabilities, @is_domain_owner) = estimate_domain_capabilities(@application.domain_name, @user_writeable_domains, @can_create, @capabilities)
  #
  #  unless @unlock_cartridges
  #    begin
  #      @cartridges, @missing_cartridges = @application_type.matching_cartridges
  #      flash.now[:error] = "No cartridges are defined for this type - all applications require at least one web cartridge" unless @cartridges.present?
  #    rescue ApplicationType::CartridgeSpecInvalid
  #      logger.debug $!
  #      flash.now[:error] = "The cartridges defined for this type are not valid.  The #{@application_type.source} may not be correct."
  #    end
  #    @disabled = @missing_cartridges.present? || @cartridges.blank?
  #  end
  #
  #  if @application.name.blank? && (suggest = Application.suggest_name_from(@cartridges))
  #    @application.name = suggest
  #    @suggesting_name = true
  #  end
  #
  #  if (create_warning = available_gears_warning(@user_writeable_domains))
  #    flash.now[:error] = create_warning
  #  end
  #
  #  user_default_domain rescue nil
  #end
  #
  #def estimate
  #  app_params = params[:application] || params
  #  app_type_params = params[:application_type] || app_params
  #
  #  scales = to_boolean(app_params[:scale])
  #  application_type = params[:id] == 'custom' ?
  #      ApplicationType.custom(app_type_params) :
  #      ApplicationType.find(params[:id])
  #  cartridges = to_boolean(params[:unlock]) ? {} : (application_type.matching_cartridges.first rescue {})
  #  application = (application_type >> Application.new(:as => current_user)).assign_attributes(app_params)
  #
  #  begin
  #    domain = Domain.find(app_params[:domain_name], :as => current_user, :params => {:include => :application_info})
  #    capabilities = domain.capabilities
  #    owner = domain.owner?
  #  rescue RestApi::ResourceNotFound => e
  #    # Assume this is a new domain name being entered, so use the user's capabilities
  #    capabilities = user_capabilities
  #    owner = true
  #  end
  #
  #  render :inline => gear_increase_indicator(cartridges, scales, application.gear_profile, false, capabilities, owner)
  #rescue => e
  #  render :inline => e.message, :status => 500
  #end
end
