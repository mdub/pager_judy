require "sinatra/base"
require "multi_json"

module PagerKit

  class FakeApiApp < Sinatra::Base

    attr_accessor :db

    get "/:things" do
      collection_name = params["things"]
      collection = []
      result = {
        collection_name => collection,
        "limit" => collection.size + 10,
        "offset" => 0,
        "more" => false
      }
      return_json(result)
    end

    post "/services" do
      service_data = json_body.fetch("service")
      db["services"] ||= {}
      id = "blah"
      db["services"][id] = service_data.merge("id" => id)
      return_json("service" => db["services"][id])
    end

    private

    def db
      @db ||= Hash.new
    end

    def json_body
      MultiJson.load(request.body)
    end

    def return_json(data, status = 200)
      content_type "application/vnd.pagerduty+json;version=2"
      [status, MultiJson.dump(data)]
    end

  end

end
