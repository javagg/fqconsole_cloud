class EditingController < ConsoleController
  def show
    user_default_domain
    app_name = Application.name_from_param(params[:application_id])
    @application = @domain.find_application app_name
    @user = User.find :one, :as => current_user
    render :nothing => true
  end
end
