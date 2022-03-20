class Admin::UsersController < ApplicationController
  before_action :find_user, only: %i[edit update destroy]
  
  def index
    @users = User.all.order(id: :desc)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: '更新しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: '削除しました'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
