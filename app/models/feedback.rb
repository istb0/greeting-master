class Feedback < ApplicationRecord
  enum emotion_type: { calm: 0, anger: 1, joy: 2, sorrow: 3, energy: 4 }

  validates :comment, length: { maximum: 255 }, presence: true
  validates :max_score, numericality: { only_integer: true }, presence: true
  validates :emotion_type, numericality: { only_integer: true }, presence: true

  def self.find_comment(result)
    emotion_type = emotion_type(result)
    max_score = max_score(result)
    find_by(max_score: max_score, emotion_type: emotion_type)
  end

  def self.emotion_type(result)
    max_emotion = [result.anger, result.sorrow, result.joy, result.energy, result.calm].max
    if max_emotion == result.anger
      'anger'
    elsif max_emotion == result.sorrow
      'sorrow'
    elsif max_emotion == result.joy
      'joy'
    elsif max_emotion == result.energy
      'energy'
    else
      'calm'
    end
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
