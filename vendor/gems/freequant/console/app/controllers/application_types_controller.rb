require Console::Engine.root.join('app', 'controllers', 'application_types_controller')

ApplicationTypesController

class ApplicationTypesController
  def index
    @capabilities = user_capabilities

    if (create_warning = available_gears_warning(user_writeable_domains))
      flash.now[:warning] = create_warning
    end

    @browse_tags = [
        ['Strategy', :strategy]
    ]

    if @tag = params[:tag].presence
      types = ApplicationType.tagged(@tag)
      @type_groups = [["Tagged with #{Array(@tag).to_sentence}", types.sort!]]

      render :search
    elsif @search = params[:search].presence
      types = ApplicationType.search(@search)
      @type_groups = [["Matches search '#{@search}'", types]]

      render :search
    else
      types = ApplicationType.all
      @featured_types = types.select{ |t| t.tags.include?(:featured) }.sample(3).sort!
      groups, other = in_groups_by_tag(types - @featured_types, [:instant_app, :java, :php, :ruby, :python])
      groups.each do |g|
        g[2] = application_types_path(:tag => g[0])
        g[1].sort!
        g[0] = I18n.t(g[0], :scope => :types, :default => g[0].to_s.titleize)
      end
      @custom_types, other = other.partition{ |t| t.tags.include?(:custom) } if RestApi.download_cartridges_enabled?
      groups << ['Other types', other.sort!] unless other.empty?
      @type_groups = groups
    end
  end
end
