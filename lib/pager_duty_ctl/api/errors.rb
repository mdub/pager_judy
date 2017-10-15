module PagerDutyCtl
  module API

    class HttpError < StandardError

      def initialize(request, response)
        @request = request
        @response = response
        super("#{request.url} - #{response.headers.fetch("Status")}")
      end

      attr_reader :request
      attr_reader :response

    end

  end
end
