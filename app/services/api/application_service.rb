module Api
  class ApplicationService

    Response = Struct.new(:success?, :data, :error, :code) do
      def failure?
        !success?
      end
    end

    def self.call(*args, &block)
      new(*args, &block).call
    end

    def success(payload = nil, code = nil)
      Response.new(true, payload, nil, code)
    end

    def failure(payload = nil, error = nil, code = nil)
      Response.new(false, payload, error, code)
    end
  end
end
