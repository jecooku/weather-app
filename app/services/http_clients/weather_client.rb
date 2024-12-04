module HttpClients
  class WeatherClient < HttpClients::BaseClient
    SOURCE_URL = 'http://api.weatherapi.com/v1/forecast.json'.freeze

    # @param [String] coords in the form of lat/long
    # @param [Hash] options for a more granular query
    # @return [Net::HTTPResponse] with the weather information
    def self.get_weather_by_address(coords, options = {})
      params = { key: ENV['WEATHER_API_TOKEN'], q: coords }.merge(options)
      uri = URI(SOURCE_URL)
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)

      # Errors handled based on https://www.weatherapi.com/docs/
      handle_response(response)

    rescue *EXCEPTIONS_LIST => e
      raise HTTPClientError, "An error has occurred: #{e.message}"
    rescue HTTPClientError => e
      Rails.logger.error(e.message)
      raise e
    end
  end
end