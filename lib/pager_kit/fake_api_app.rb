require "sinatra/base"
require "multi_json"

module PagerKit

  class FakeApiApp < Sinatra::Base

    def db
      @db ||= Hash.new
    end

    attr_writer :db

    # List a collection
    #
    get "/:things" do
      collection_type = params["things"]
      collection = db.fetch(collection_type, {})
      result = {
        collection_type => collection.map { |id, data|
          data.merge("id" => id)
        },
        "limit" => collection.size + 10,
        "offset" => 0,
        "more" => false
      }
      return_json(result)
    end

    # Show an item
    #
    get "/:things/:id" do
      collection_type = params["things"]
      id = params["id"]
      collection = db.fetch(collection_type, {})
      item_type = collection_type.chomp("s")
      return_error(404, "#{item_type} not found") unless collection.key?(id)
      result = {
        item_type => collection.fetch(id).merge("id" => id)
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

    def json_body
      MultiJson.load(request.body)
    end

    def return_json(data, status = 200)
      content_type "application/vnd.pagerduty+json;version=2"
      [status, MultiJson.dump(data)]
    end

    def return_error(status, message)
      data = {
        "error" => {
          "message" => message
        }
      }
      content_type "application/json"
      halt status, MultiJson.dump(data)
    end

  end

end
