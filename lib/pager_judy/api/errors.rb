module PagerJudy
  module API

    # An error from the PagerDuty REST API.
    #
    class HttpError < StandardError

      def initialize(request, response)
        @request = request
        @response = response
        super(response.headers["Status"])
      end

      attr_reader :request
      attr_reader :response

    end

  end
end
