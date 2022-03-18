class RanksController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @score_ranks = Result.score_ranks
    @score = 'score'
    @calm_ranks = Result.calm_ranks
    @calm = 'calm'
    @anger_ranks = Result.anger_ranks
    @anger = 'anger'
    @joy_ranks = Result.joy_ranks
    @joy = 'joy'
    @sorrow_ranks = Result.sorrow_ranks
    @sorrow = 'sorrow'
    @energy_ranks = Result.energy_ranks
    @energy = 'energy'
  end
end
