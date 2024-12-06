module Api
  class ApplicationService

    # Struct representing the possible values of a HTTP response
    Response = Struct.new(:success?, :data, :error, :code) do
      def failure?
        !success?
      end
    end

    def self.call(*args, &block)
      new(*args, &block).call
    end

    # Used to return a successful HTTP response in the controller
    # @param [nil] payload to be returned in the response
    # @param [nil] code of the responce
    # @return [anonymous Struct] a response struct with the response attributes
    def success(payload = nil, code = nil)
      Response.new(true, payload, nil, code)
    end

    # Used to return a failed HTTP response in the controller
    # @param [nil] payload to be returned in the response
    # @param [nil] error contains the error of the HTTP response or is manually set
    # @param [nil] code of the response
    # @return [anonymous Struct] a response struct with the response attributes
    def failure(payload = nil, error = nil, code = nil)
      Response.new(false, payload, error, code)
    end
  end
end
