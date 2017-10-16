module PagerKit

  class HttpError < StandardError

    def initialize(request, response)
      @request = request
      @response = response
      super("#{request.url} - #{response.code}")
    end

    attr_reader :request
    attr_reader :response

  end

end
