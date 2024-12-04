module HttpClients
  class BaseClient
    # List of errors for the children clients. This helps identify the root sources of the errors when they occur.
    class HTTPClientError < StandardError; end
    class BadRequestError < HTTPClientError; end
    class ApiKeyError < HTTPClientError; end
    class AccessTokenExpiredError < HTTPClientError; end
    class NotFoundError < HTTPClientError; end
    class RateLimitedError < HTTPClientError; end

    EXCEPTIONS_LIST = [Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
                       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError].freeze

    # Handles the response and raises errors based on the HTTP code
    # @param [Object] response object from the HTTP request
    def self.handle_response(response)
      case response.code
      when '200'
        response
      when '400'
        raise BadRequestError, I18n.t('errors.bad_request')
      when '401'
        raise ApiKeyError, I18n.t('errors.token_expired')
      when '403'
        raise AccessTokenExpiredError, I18n.t('errors.token_expired')
      when '404'
        raise NotFoundError, I18n.t('errors.not_found')
      when '429'
        raise RateLimitedError, I18n.t('errors.rate_limited')
      else
        raise HTTPClientError, I18n.t('errors.generic')
      end
    end
  end
end