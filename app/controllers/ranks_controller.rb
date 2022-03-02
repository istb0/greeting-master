class RanksController < ApplicationController
  def index
    result = Result.all
    @score_ranks = result.score_ranks
    @score = 'score'
    @calm_ranks = result.calm_ranks
    @calm = 'calm'
    @anger_ranks = result.anger_ranks
    @anger = 'anger'
    @joy_ranks = result.joy_ranks
    @joy = 'joy'
    @sorrow_ranks = result.sorrow_ranks
    @sorrow = 'sorrow'
    @energy_ranks = result.energy_ranks
    @energy = 'energy'
  end
end
