module Api
  class AddressService < ApplicationService
    attr_accessor :params

    # Initialize the AddressService with params
    # @param [Hash] params
    def initialize(params)
      @params = params
    end

    # Produces the hash key of the given input
    # @return [String] Key of the cache
    def key
      @key ||= Digest::SHA256.hexdigest(params[:input])
    end

    # Fetch requested address by checking the cache first, if not present, then store the result in the cache
    # @return [Result] with either a success or failure results
    def call
      cached = Rails.cache.fetch(key).present?
      response = Rails.cache.fetch(key, expires_in: 30.minute) do
        ::HttpClients::AddressClient.get_address_suggestion(params[:input])
      end

      if response.code == '200'
        response = { data: response.body.force_encoding("UTF-8"), cached: cached }
        success(response,'200')
      else
        failure(response, "Request failed with code #{response.code}", response.code)
      end
    end
  end
end