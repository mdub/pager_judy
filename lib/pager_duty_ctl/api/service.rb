require "pager_duty_ctl/api/client"
require "json"

module PagerDutyCtl

  module PagerDutyApi

    class Service

      ENDPOINT_BASE_PATH = "/services"

      def initialize(client = nil)
        @client = client
      end

      def create(data)
        response = client.post(ENDPOINT_BASE_PATH, data.to_json)
        JSON.parse(response.body)["service"]
      end

      def update(id, data)
        response = client.put("#{ENDPOINT_BASE_PATH}/#{id}", data.to_json)
        JSON.parse(response.body)["service"]
      end

      def delete(id)
        client.delete("#{ENDPOINT_BASE_PATH}/#{id}")
      end

      def get(id)
        response = client.get("#{ENDPOINT_BASE_PATH}/#{id}")
        JSON.parse(response.body)["service"]
      end

      def list(name = nil)
        query_string = "&query=#{name}" unless name.nil?
        response = client.get("#{ENDPOINT_BASE_PATH}?time_zone=Australia/Melbourne#{query_string}")
        JSON.parse(response)["services"]
      end

      def create_or_update(data)
        existing = list(data["name"])
        if existing.any?
          update(existing.first["id"], data)
        else
          create(data)
        end
      end

      private

      def client
        @client ||= Client.new
      end

    end
  end
end
