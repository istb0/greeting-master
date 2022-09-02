class Feedback < ApplicationRecord
  enum emotion_type: { calm: 0, anger: 1, joy: 2, sorrow: 3, energy: 4 }

  validates :comment, length: { maximum: 255 }, presence: true
  validates :max_score, numericality: { only_integer: true }, presence: true
  validates :emotion_type, numericality: { only_integer: true }, presence: true

  def self.find_comment(result)
    find_by(max_score: max_score(result), emotion_type: emotion_type(result))
  end

  def self.emotion_type(result)
    emotion = { anger: result.anger, sorrow: result.sorrow, joy: result.joy, energy: result.energy, calm: result.calm }
    emotion.max_by { |e| e[1] }[0]
  end

  def self.max_score(result)
    if result.score < 20
      20
    elsif result.score < 40
      40
    elsif result.score < 60
      60
    elsif result.score < 80
      80
    else
      100
    end
  end
end
