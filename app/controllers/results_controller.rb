class ResultsController < ApplicationController
  before_action :set_result, only: %i[show destroy]
  skip_before_action :require_login, only: %i[create show]

  def create
    # @result = Result.new
    # @result.analyse(result_params)
    # 以下本リリースまでの一時的処置
    joy = rand(50)
    energy = rand(50)
    anger = rand(50)
    sorrow = rand(50)
    @result = Result.new(
      score: (50 + (0.5 * (joy + energy - anger - sorrow))).round,
      calm: rand(50),
      anger: anger,
      joy: joy,
      sorrow: sorrow,
      energy: energy,
      greeting_id: result_params[:greeting_id]
    )
    @result.voice.attach(params[:voice])
    # ここまで
    render json: { url: result_path(@result) } if @result.save
  end

  def show
    @greeting = Greeting.find(@result.greeting_id)
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
