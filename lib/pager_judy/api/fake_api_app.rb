require "securerandom"
require "sinatra/base"
require "multi_json"

module PagerJudy
  module API

    # This little Rack app is designed to fake the PagerDuty REST API.
    #
    # It's pretty much just CRUD:
    #
    #   GET  /COLLECTION
    #   POST /COLLECTION
    #   GET  /COLLECTION/ID
    #   PUT  /COLLECTION/ID
    #
    class FakeApp < Sinatra::Base

      def db
        # The "database" is just a big Hash. We make it an instance variable,
        # so it sticks around between requests.
        @db ||= {}
      end

      attr_writer :db

      def collection_type
        params["collection_type"]
      end

      def collection
        db[collection_type] ||= {}
      end

      def item_type
        collection_type.chomp("s")
      end

      def item_id
        @item_id ||= params["item_id"]
      end

      def item
        return_error(404, "#{item_type} #{item_id} not found") unless collection.key?(item_id)
        collection.fetch(item_id)
      end

      def item_data
        item.merge("id" => item_id)
      end

      def sub_collection_type
        params["sub_collection_type"]
      end

      def sub_collection
        item[sub_collection_type] ||= {}
      end

      def sub_item_type
        sub_collection_type.chomp("s")
      end

      def sub_item_id
        @sub_item_id ||= params["sub_item_id"]
      end

      def sub_item_exists?
        sub_collection.key?(sub_item_id)
      end

      def sub_item
        return_error(404, "#{sub_item_type} #{sub_item_id} not found") unless sub_collection.key?(sub_item_id)
        sub_collection.fetch(sub_item_id)
      end

      def sub_item_data
        sub_collection.fetch(sub_item_id).merge("id" => sub_item_id)
      end

      # List a collection
      #
      get "/:collection_type" do
        result = {
          collection_type => collection.map do |id, data|
            data.merge("id" => id)
          end,
          "limit" => collection.size + 10,
          "offset" => 0,
          "more" => false
        }
        return_json(result)
      end

      # Show an item
      #
      get "/:collection_type/:item_id" do
        return_json(item_type => item_data)
      end

      # Create an item
      #
      post "/:collection_type" do
        data = json_body.fetch(item_type)
        data.delete("id")
        @item_id = SecureRandom.hex(4)
        collection[@item_id] = data
        return_json({ item_type => item_data }, 201)
      end

      # Update an item
      #
      put "/:collection_type/:item_id" do
        data = json_body.fetch(item_type)
        data.delete("id")
        data.delete("type")
        item.merge!(data)
        return_json({ item_type => item_data }, 200)
      end

      # Create a sub-item
      #
      post "/:collection_type/:item_id/:sub_collection_type" do
        data = json_body.fetch(sub_item_type)
        data.delete("id")
        @sub_item_id = SecureRandom.hex(4)
        sub_collection[@sub_item_id] = data
        return_json({ sub_item_type => sub_item_data }, 201)
      end

      # Update a sub-item
      #
      put "/:collection_type/:item_id/:sub_collection_type/:sub_item_id" do
        data = json_body.fetch(sub_item_type)
        data.delete("id")
        data.delete("type")
        sub_item.merge!(data)
        return_json({ sub_item_type => sub_item_data }, 200)
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
end
