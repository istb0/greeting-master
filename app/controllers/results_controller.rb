class ResultsController < ApplicationController
  def create
    @result = Result.new
    @result.analyse(result_params[:voice], result_params[:greeting_id])
    # joy = rand(50)
    # energy = rand(50)
    # anger = rand(50)
    # sorrow = rand(50)
    # @result = Result.new(
    #   score: (50 + (0.5 * (joy + energy - anger - sorrow))).round,
    #   calm: rand(50),
    #   anger: anger,
    #   joy: joy,
    #   sorrow: sorrow,
    #   energy: energy,
    #   greeting_id: result_params[:greeting_id]
    # )
    # @result.voice.attach(params[:voice])
    render json: { url: result_path(@result) } if @result.save
  end

  def show
    @result = Result.find(params[:id])
    @greeting = Greeting.find(@result.greeting_id)
    @feedback = Feedback.find_comment(@result)
  end

  private

  def result_params
    params.permit(:voice, :greeting_id)
  end
end
