class Admin::ResultsController < Admin::BaseController
  def index
    @results = Result.all.includes(:user, :greeting).order(created_at: :desc)
  end

  def destroy
    result = Result.find(params[:id])
    result.destroy!
    redirect_to admin_results_path
  end
end
