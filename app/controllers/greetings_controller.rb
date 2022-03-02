class GreetingsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @greetings = Greeting.all
  end

  def show
    @greeting = Greeting.find(params[:id])
  end
end
