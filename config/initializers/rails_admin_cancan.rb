require 'rails_admin/main_controller'

module RailsAdmin
  class MainController < RailsAdmin::ApplicationController
    rescue_from CanCan::AccessDenied do |_exception|
      flash[:alert] = 'このページへのアクセスは許可されていません'
      redirect_to main_app.root_path
    end
  end
end
