class Result < ApplicationRecord
  include IdGenerator
  belongs_to :greeting
  belongs_to :user

  has_one_attached :voice

  validates :score, numericality: { only_integer: true }, presence: true
  validates :calm, numericality: { only_integer: true }, presence: true
  validates :anger, numericality: { only_integer: true }, presence: true
  validates :joy, numericality: { only_integer: true }, presence: true
  validates :sorrow, numericality: { only_integer: true }, presence: true
  validates :energy, numericality: { only_integer: true }, presence: true

  scope :own_results, ->(current_user) { where(user_id: current_user.id).includes(:user, :greeting).order(created_at: :desc) }

  scope :score_ranks, -> { includes(:user, :greeting).order(score: :desc).limit(3).select(:score, :user_id, :greeting_id) }
  scope :calm_ranks, -> { includes(:user, :greeting).order(calm: :desc).limit(3).select(:calm, :user_id, :greeting_id) }
  scope :anger_ranks, -> { includes(:user, :greeting).order(anger: :desc).limit(3).select(:anger, :user_id, :greeting_id) }
  scope :joy_ranks, -> { includes(:user, :greeting).order(joy: :desc).limit(3).select(:joy, :user_id, :greeting_id) }
  scope :sorrow_ranks, -> { includes(:user, :greeting).order(sorrow: :desc).limit(3).select(:sorrow, :user_id, :greeting_id) }
  scope :energy_ranks, -> { includes(:user, :greeting).order(energy: :desc).limit(3).select(:energy, :user_id, :greeting_id) }

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
end
