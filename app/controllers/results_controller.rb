class ResultsController < ApplicationController

  def analyse
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
    render json: response
  end

  def show
    @greeting = Greeting.find(params[:greeting_id])
    hash = JSON.parse(params[:data])
    @calm = hash['calm']
    @anger = hash['anger']
    @joy = hash['joy']
    @sorrow = hash['sorrow']
    @energy = hash['energy']
    @score = (@calm*0.1 + @joy*0.95 + @energy*0.95 - @anger*0.7 - @sorrow*0.3).round
    if score < 0
      @score = 0
    else
      @score = score
    end
  end
end
