class Admin::BaseController < ApplicationController
  before_action :check_admin

  private

  def not_authenticated
    flash[:alert] = 'ログインしてください'
    redirect_to admin_login_path
  end

  def check_admin
    redirect_to admin_login_path, alert: '権限がありません' unless current_user.admin?
  end
end
