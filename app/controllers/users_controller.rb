class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]
  skip_before_action :require_login, only: %i[index new create]

  def show;end

  def new
    @user = User.new
  end

  def edit;end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: 'ユーザー登録に成功しました。'
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました。'
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: 'ユーザー情報を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
