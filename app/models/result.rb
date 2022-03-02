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

  def analyse(formdata)
    connection = Faraday.new(Rails.application.credentials[:empath][:endpoint]) do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end
    response = connection.post do |req|
      req.body = {
        apikey: Rails.application.credentials[:empath][:apikey],
        wav: Faraday::Multipart::FilePart.new(formdata[:voice], 'audio/wav')
      }
    end
    # logger.debug(response.body)
    judge(formdata, response)
  end

  def judge(formdata, response)
    hash = JSON.parse(response.body)
    self.calm = hash['calm']
    self.anger = hash['anger']
    self.joy = hash['joy']
    self.sorrow = hash['sorrow']
    self.energy = hash['energy']
    self.score = (50 + (0.5 * (joy + energy - anger - sorrow))).round
    self.greeting_id = formdata[:greeting_id]
    voice.attach(formdata[:voice])
  end

  scope :score_ranks, -> { includes(:greeting).order(score: :desc).limit(5).select(:score, :greeting_id) }
  scope :calm_ranks, -> { includes(:greeting).order(calm: :desc).limit(5).select(:calm, :greeting_id) }
  scope :anger_ranks, -> { includes(:greeting).order(anger: :desc).limit(5).select(:anger, :greeting_id) }
  scope :joy_ranks, -> { includes(:greeting).order(joy: :desc).limit(5).select(:joy, :greeting_id) }
  scope :sorrow_ranks, -> { includes(:greeting).order(sorrow: :desc).limit(5).select(:sorrow, :greeting_id) }
  scope :energy_ranks, -> { includes(:greeting).order(energy: :desc).limit(5).select(:energy, :greeting_id) }
end
