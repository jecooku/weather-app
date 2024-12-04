module Api
  module V1
    class WeatherController < ApplicationController

      def forecast
        lat, long = weather_params[:address].split(',').map(&:to_f)
        key = ::GeoHash.new(lat, long).value.to_s

        cached = Rails.cache.fetch(key).present?
        response = Rails.cache.fetch(key, expires_in: 30.minute) do
          ::HttpClients::WeatherClient.get_weather_by_address(params[:address], days:5)
        end

        response = { data: response.body.force_encoding("UTF-8"), cached: cached }

        render json: response
      end

      def weather_params
        params.permit(:address).tap do |parameters|
          raise ActionController::ParameterMissing.new('address') unless parameters[:address].present?
        end
      end
    end
  end
end