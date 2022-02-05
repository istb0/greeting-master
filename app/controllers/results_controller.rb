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
        wav: Faraday::Multipart::FilePart.new(result_params[:voice], 'audio/wav')
      }
    end
  end

  private

  def result_params
    params.permit(:voice)
  end
end
