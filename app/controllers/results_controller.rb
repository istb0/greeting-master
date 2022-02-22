class ResultsController < ApplicationController
  def create
    @result = Result.new
    @result.analyse(params[:voice], params[:greeting_id])

    render json: { url: result_path(@result) } if @result.save
  end

  def show
    @result = Result.find(params[:id])
    @greeting = Greeting.find(@result.greeting_id)
  end
end
