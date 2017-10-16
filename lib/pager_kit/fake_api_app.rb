require "sinatra/base"
require "multi_json"

module PagerKit

  class FakeApiApp < Sinatra::Base

    def db
      @db ||= Hash.new
    end

    attr_writer :db

    def collection_type
      collection_type = params["collection_type"]
    end

    def collection
      db[collection_type] ||= {}
    end

    def item_type
      collection_type.chomp("s")
    end

    def item_id
      params["item_id"]
    end

    # List a collection
    #
    get "/:collection_type" do
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
    get "/:collection_type/:item_id" do
      item = collection[item_id]
      return_error(404, "#{item_type} #{item_id} not found") if item.nil?
      return_json(item_type => item.merge("id" => item_id))
    end

    # Create an item
    #
    post "/:collection_type" do
      data = json_body.fetch(item_type)
      item_id = SecureRandom.hex(4)
      collection[item_id] = data
      result = {
        item_type => data.merge("id" => item_id)
      }
      return_json(result, 201)
    end

    not_found do
      return_error 404, "Not found"
    end

    private

    def json_body
      MultiJson.load(request.body)
    rescue MultiJson::ParseError
      {}
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
