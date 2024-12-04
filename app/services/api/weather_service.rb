module Api
  class WeatherService < ApplicationService
    attr_accessor :params

    # Initialize the WeatherService with params
    # @param [Hash] params
    def initialize(params)
      @params = params
    end

    # Produces the hash key of the given input. It gets the latitude and longitude from the input to produce the key
    # @return [String] Key of the cache
    def key
      lat, long = params[:address].split(',').map(&:to_f)

      @key ||= ::GeoHash.new(lat, long).value.to_s
    end

    # Fetch the weather info for the given address by checking the cache first, if not present
    # then store the result in the cache
    # @return [Result] with either a success or failure results
    def call
      cached = Rails.cache.fetch(key).present?
      response = Rails.cache.fetch(key, expires_in: 30.minute) do
        ::HttpClients::WeatherClient.get_weather_by_address(params[:address], days:5)
      end

      if response.code == '200'
        response = { data: response.body.force_encoding("UTF-8"), cached: cached }
        success(response, '200')
      else
        failure(response, "Request failed with code #{response.code}", response.code)
      end
    end
  end
end