class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: 'ユーザー情報を更新しました'
    else
      render :show
    end
  end

  private

  def set_user
    if current_user.present?
      @user = User.find(current_user.id)
      # showとupdateを同じページにしたため、これで分けないと
      # バリデーションに引っかかる→showに戻る→ページ上では変更されている（内部的には変更していない）
      # というおかしな表記になってしまうため。原因はエラー文表示時は@userに情報が入るから、@user.nameで
      # 表記しているとバリデーションエラー時の情報が入ってしまうこと
      @show_user = User.find(current_user.id)
    end
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
