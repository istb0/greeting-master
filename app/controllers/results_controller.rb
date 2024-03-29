class ResultsController < ApplicationController
  before_action :set_result, only: %i[show destroy]
  skip_before_action :require_login, only: %i[create show]

  def index
    @results = current_user.results.order(created_at: :desc)
  end

  def create
    @result = Result.new
    @result.recognize(result_params)
    @result.user_id = current_user.id if logged_in?
    if @result.save
      render json: { url: result_path(@result) }
    else
      render json: @result.greeting.phrase
    end
  end

  def show
    @greeting = @result.greeting
    @feedback = Feedback.find_comment(@result)
  end

  def destroy
    @result.destroy!
    redirect_to user_results_path(current_user)
  end

  private

  def set_result
    @result = Result.find(params[:id])
  end

  def result_params
    params.permit(:voice, :greeting_id)
  end
end
