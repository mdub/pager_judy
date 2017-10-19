require "spec_helper"

require "rack/test"
require "pager_judy/api/fake_api_app"

RSpec.describe PagerJudy::API::FakeApp do

  PAGER_DUTY_V2_JSON = "application/vnd.pagerduty+json;version=2".freeze

  include Rack::Test::Methods

  let(:db) { {} }

  let(:app) do
    described_class.new!
  end

  before do
    app.db = db
    header "Accept", PAGER_DUTY_V2_JSON
    header "Content-Type", "application/json"
  end

  def body_json
    MultiJson.load(last_response.body)
  end

  context "fresh" do

    describe "GET /collection" do

      before do
        get "/things"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns PagerDuty JSON" do
        expect(last_response.content_type).to eq(PAGER_DUTY_V2_JSON)
      end

      it "returns an empty collection" do
        expect(body_json).to match_pact(
          "things" => []
        )
      end

      it "includes pagination details" do
        expect(body_json).to match_pact(
          "offset" => 0,
          "more" => false
        )
      end

    end

    describe "GET /collection/item" do

      before do
        get "/things/thing1"
      end

      it "fails with 404" do
        expect(last_response.status).to eq(404)
      end

    end

  end

  context "with existing data" do

    let(:db) do
      YAML.safe_load(<<-DATA)
        things:
          T1:
            name: Thing One
          T2:
            name: Thing Two
      DATA
    end

    describe "GET /collection" do

      before do
        get "/things"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns the data" do
        expect(body_json).to match_pact(
          "things" => [
            {
              "id" => "T1",
              "name" => "Thing One"
            },
            {
              "id" => "T2",
              "name" => "Thing Two"
            }
          ]
        )
      end

    end

    describe "POST /collection" do

      let(:thing_data) do
        {
          "name" => "Third thing"
        }
      end

      before do
        post "/things", MultiJson.dump("thing" => thing_data)
      end

      it "succeeds" do
        expect(last_response.status).to eq(201)
      end

      def generated_id
        body_json.dig("thing", "id")
      end

      it "generates an id" do
        expect(generated_id).not_to be_nil
      end

      it "stores the data" do
        expect(db.dig("things", generated_id, "name")).to eq("Third thing")
      end

      it "returns the data" do
        expect(body_json).to match_pact(
          "thing" => {
            "id" => generated_id,
            "name" => "Third thing"
          }
        )
      end

    end

    describe "GET /collection/item" do

      before do
        get "/things/T1"
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "returns data" do
        expect(body_json).to match_pact(
          "thing" => {
            "id" => "T1",
            "name" => "Thing One"
          }
        )
      end

    end

    describe "PUT /collection/item" do

      let(:thing_data) do
        {
          "name" => "New name",
          "extra" => "stuff"
        }
      end

      before do
        put "/things/T2", MultiJson.dump("thing" => thing_data)
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "update the data" do
        expect(db.fetch("things")).to match_pact(
          "T1" => {
            "name" => "Thing One"
          },
          "T2" => {
            "name" => "New name",
            "extra" => "stuff"
          }
        )
      end

      it "returns data" do
        expect(body_json).to match_pact(
          "thing" => {
            "id" => "T2",
            "name" => "New name",
            "extra" => "stuff"
          }
        )
      end

    end

    describe "POST /collection/ID/subcollection" do

      let(:db) do
        YAML.safe_load(<<-DATA)
          things:
            T1:
              name: Thing One
        DATA
      end

      let(:part_data) do
        {
          "name" => "Part 1"
        }
      end

      before do
        post "/things/T1/parts", MultiJson.dump("part" => part_data)
      end

      it "succeeds" do
        expect(last_response.status).to eq(201)
      end

      def generated_id
        body_json.dig("part", "id")
      end

      it "generates an id" do
        expect(generated_id).not_to be_nil
      end

      it "stores the data" do
        expect(db.dig("things", "T1", "parts", generated_id, "name")).to eq("Part 1")
      end

      it "returns the data" do
        expect(body_json).to match_pact(
          "part" => {
            "id" => generated_id,
            "name" => "Part 1"
          }
        )
      end

    end

    describe "PUT /collection/ID/subcollection/item" do

      let(:db) do
        YAML.safe_load(<<-DATA)
          things:
            T1:
              parts:
                P1:
                  name: Part One
        DATA
      end

      let(:part_data) do
        {
          "name" => "New name",
          "extra" => "stuff"
        }
      end

      before do
        put "/things/T1/parts/P1", MultiJson.dump("part" => part_data)
      end

      it "succeeds" do
        expect(last_response.status).to eq(200)
      end

      it "update the data" do
        expect(db.dig("things", "T1", "parts")).to match_pact(
          "P1" => {
            "name" => "New name",
            "extra" => "stuff"
          }
        )
      end

      it "returns data" do
        expect(body_json).to match_pact(
          "part" => {
            "id" => "P1",
            "name" => "New name",
            "extra" => "stuff"
          }
        )
      end

    end

  end

end
