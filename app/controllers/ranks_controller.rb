class RanksController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @ranks = {
      score: Result.score_ranks,
      calm: Result.calm_ranks,
      anger: Result.anger_ranks,
      joy: Result.joy_ranks,
      sorrow: Result.sorrow_ranks,
      energy: Result.energy_ranks
    }
  end
end
