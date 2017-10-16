require "spec_helper"

require "rack/test"
require "pager_kit/fake_api_app"

RSpec.describe PagerKit::FakeApiApp do

  include Rack::Test::Methods

  def app
    described_class.new!
  end

  PAGER_DUTY_V2_JSON = "application/vnd.pagerduty+json;version=2"

  before do
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

  end

end
