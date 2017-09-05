require "rest-client"
require "uri"

module PagerDutyCtl

  module PagerDutyApi

    class Client

      BASE_URI = "https://api.pagerduty.com"

      def initialize(api_token = nil)
        @api_token = api_token || ENV['PAGER_DUTY_API_TOKEN']
      end

      def get(path)
        RestClient.get(full_uri_for(path), headers = client_config)
      end

      def post(path, payload)
        RestClient.post(full_uri_for(path), payload, headers = client_config)
      end

      def put(path, payload)
        RestClient.put(full_uri_for(path), payload, headers = client_config)
      end

      def delete(path)
        RestClient.delete(full_uri_for(path), headers = client_config)
      end

      private

      attr_reader :api_token

      def client_config
        {
          "Content-Type" => "application/json",
          "Authorization" => "Token token=#{api_token}",
          "Accept" => "application/vnd.pagerduty+json;version=2"
        }
      end

      def full_uri_for(path)
        "#{BASE_URI}#{path}"
      end
    end
  end
end
