class Greeting < ApplicationRecord
  validates :phrase, length: { maximum: 50 }, presence: true
  validates :subtitle, length: { maximum: 255 }
end
