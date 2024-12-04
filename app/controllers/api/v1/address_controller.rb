module Api
  module V1
    class AddressController < ApplicationController
      def index
        key = Digest::SHA256.hexdigest(address_params[:input])

        cached = Rails.cache.fetch(key).present?
        response = Rails.cache.fetch(key, expires_in: 30.minute) do
          ::HttpClients::AddressClient.get_address_suggestion(params[:input])
        end
          response = { data: response.body.force_encoding("UTF-8"), cached: cached }
          render json: response
      end

      def address_params
        params.permit(:input).tap do |parameters|
          raise ActionController::ParameterMissing.new('input') unless parameters[:input].present?
        end
      end
    end
  end
end