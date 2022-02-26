class Result < ApplicationRecord
  include IdGenerator
  belongs_to :greeting

  has_one_attached :voice

  validates :score, numericality: { only_integer: true }, presence: true
  validates :calm, numericality: { only_integer: true }, presence: true
  validates :anger, numericality: { only_integer: true }, presence: true
  validates :joy, numericality: { only_integer: true }, presence: true
  validates :sorrow, numericality: { only_integer: true }, presence: true
  validates :energy, numericality: { only_integer: true }, presence: true

  def analyse(voice_data, greeting_id)
    connection = Faraday.new(Rails.application.credentials[:empath][:endpoint]) do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end
    response = connection.post do |req|
      req.body = {
        apikey: Rails.application.credentials[:empath][:apikey],
        wav: Faraday::Multipart::FilePart.new(voice_data, 'audio/wav')
      }
    end
    logger.debug(response.body)
    judge(voice_data, greeting_id, response)
  end

  def judge(voice_data, greeting_id, response)
    hash = JSON.parse(response.body)
    self.calm = hash['calm']
    self.anger = hash['anger']
    self.joy = hash['joy']
    self.sorrow = hash['sorrow']
    self.energy = hash['energy']
    self.score = (50 + (0.5 * (joy + energy - anger - sorrow))).round
    self.greeting_id = greeting_id
    self.voice.attach(voice_data)
  end
end
