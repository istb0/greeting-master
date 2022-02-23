class Feedback < ApplicationRecord
  enum emotion_type: { calm: 0, anger: 1, joy: 2, sorrow: 3, energy: 4 }

  validates :comment, length: { maximum: 255 }, presence: true
  validates :max_score, numericality: { only_integer: true }, presence: true
  validates :emotion_type, numericality: { only_integer: true }, presence: true
end
