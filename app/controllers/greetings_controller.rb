class GreetingsController < ApplicationController

  def index
    @greetings = Greeting.all
  end

  def show
    @greeting = Greeting.find(params[:id])
  end
end
