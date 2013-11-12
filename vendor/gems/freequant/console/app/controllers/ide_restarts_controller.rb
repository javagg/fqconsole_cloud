class IdeRestartsController < ConsoleController
  def show
    user_default_domain
    @application = @domain.find_application params[:application_id]
  end

  def update
    user_default_domain
    @application = @domain.find_application params[:application_id]

    @application.restart_ide!

    message = @application.messages.first || "The application('#{@application.name}')'s ide has been restarted"
    redirect_to @application, :flash => {:success => message.to_s}
  end
end