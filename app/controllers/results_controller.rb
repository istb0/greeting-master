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
    @score = 50 + @calm * 0.2 + (@joy + @energy) * 0.4 - (@anger + @sorrow) * 0.5
  end

#  private
#
#  def result_params
#    params.permit(:voice, :data)
#  end
end
