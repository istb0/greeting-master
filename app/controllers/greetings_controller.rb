class GreetingsController < ApplicationController

  def index
    @greetings = Greeting.all
  end
end
