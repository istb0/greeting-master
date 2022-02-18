class ResultsController < ApplicationController

  def create
    connection = Faraday.new(Rails.application.credentials[:empath][:endpoint]) do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end
    response = connection.post do |req|
      req.body = {
        apikey: Rails.application.credentials[:empath][:apikey],
        wav: Faraday::Multipart::FilePart.new(params[:voice], 'audio/wav')
      }
    end
    p response.body

    hash = JSON.parse(response.body)
    calm = hash['calm']
    anger = hash['anger']
    joy = hash['joy']
    sorrow = hash['sorrow']
    energy = hash['energy']
    tmp = (calm*0.1 + joy*0.95 + energy*0.95 - anger*0.7 - sorrow*0.3).round
    if tmp < 0
      score = 0
    else
      score = tmp
    end
    @result = Result.new(
      score: score,
      calm: calm,
      anger: anger,
      joy: joy,
      sorrow: sorrow,
      energy: energy,
      greeting_id: params[:greeting_id]
    )
    if @result.save
      render json: { url: result_path(@result) }
    end
  end

  def show
    @result = Result.find(params[:id])
    @greeting = Greeting.find(@result.greeting_id)
  end
end
