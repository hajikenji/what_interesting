class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # rescue_from CanCan::AccessDenied, with: :go_end
  # before_action :res
  # before_action :go_end, if: :main_controller?
  # before_action :go_end, only: :admin
  # before_action :go_end, only: ["dashboard"]
  
  # # def action
  # #   if action == :access
  # #     true
  # #   end
  # # end
  # # before_action :check_admin_authorization

  # # def check_admin_authorization
  # #   redirect_to articles_path if request.path.start_with?('/admin')
  # # end
  # def res
  #   rescue_from CanCan::AccessDenied do |exception|
  #     respond_to do |format|
  #       format.json { head :forbidden }
  #       format.html { redirect_to root_path, alert: exception.message }
  #     end
  #   end
  # end

  # rescue_from LoadError do |exception|
  #   respond_to do |format|
  #     format.json { head :forbidden }
  #     format.html { redirect_to root_path, alert: exception.message }
  #   end
  # end

  # # before_action :res
  # # authorize_resource :class => false
  # # binding.irb

  # # def res
  # #   rescue_from CanCan::AccessDenied do |exception|
  # #     redirect_to articles_path, alert: exception.message
  # #   end
  # # end

  # # def res
  # #   rescue_from CanCan::AccessDenied, with: :go_end
  # # end


  # def go_end
  #   redirect_to articles_path
  #   binding.irb
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
