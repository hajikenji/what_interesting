class My::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # ゲスト用が不要になれば中身は消すコードたち
  def show
    # binding.pry
    # ゲストユーザー兼ゲスト管理者用if文
    if params[:id] == 'guest' || params[:id] == 'admin'
      if User.find_by(email: 'q@a.com')
        @user = User.find_by(email: 'q@a.com') 
      else
        @user = User.create(name: 'test1', email: 'q@a.com', password: 'qqqqqq', admin: true)
        @user.confirm
      end
      sign_in @user
      @current_user = @user
    end
    redirect_to rails_admin_path if params[:id] == 'admin'
  end

  def update
    if @user.update(user_params)
      redirect_to my_user_path(current_user), notice: 'ユーザー情報を更新しました'
    else
      render :show
    end
  end

  private

  def set_user
    if current_user.present?
      @user = User.find(current_user.id)
    end

  end

  def user_params
    params.require(:user).permit(:name)
  end
end
