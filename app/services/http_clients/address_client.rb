module HttpClients
  class AddressClient < BaseClient
    SOURCE_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/'.freeze
    RETRIES_LIMIT = 3

    # @param [String] a complete or partial string of the address
    # @param [Hash] options hash for a more detailed query
    # @return [Net::HTTPResponse] the response of the request with address suggestions
    def self.get_address_suggestion(address, options = {}, retries = 0)
      params = { access_token: ENV['ADDRESS_API_TOKEN'] }.merge(options)
      uri = URI("#{SOURCE_URL}#{URI.encode_www_form_component(address)}.json")
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)

      # Errors handled based on https://docs.mapbox.com/api/search/geocoding/#geocoding-api-errors
      handle_response(response)

    rescue *EXCEPTIONS_LIST => e
      raise HTTPClientError, "An error has occurred: #{e.message}"
    rescue RateLimitedError
      raise RateLimitedError, "Rate limit reached after #{retries} tries" if retries >= RETRIES_LIMIT
      sleep(SecureRandom.random_number(3.0))
      get_address_suggestion(address, options, retries + 1)
    rescue HTTPClientError => e
      Rails.logger.error(e.message)
      raise e
    end
  end
end
