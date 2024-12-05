module Api
  module V1
    class WeatherController < ApplicationController

      def forecast
        response = ::Api::WeatherService.call(weather_params)

        render json: response, status: response.code
      end

      def weather_params
        params.permit(:address).tap do |parameters|
          raise ActionController::ParameterMissing.new('address') unless parameters[:address].present?
        end
      end
    end
  end
end