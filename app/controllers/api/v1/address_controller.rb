module Api
  module V1
    class AddressController < ApplicationController
      def index
        response = ::Api::AddressService.call(address_params)

        render json: response, status: response.code
      end

      def address_params
        params.permit(:input).tap do |parameters|
          raise ActionController::ParameterMissing.new('input') unless parameters[:input].present?
        end
      end
    end
  end
end