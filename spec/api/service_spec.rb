require "pager_duty_ctl/api/service"
require "spec_helper"
require "json"

RSpec.describe PagerDutyCtl::PagerDutyApi::Service do

  let(:service_properties) do
    {
      "name" => "GDE Test service",
      "description" => "Testing",
      "escalation_policy" => {
        "id" => "PO3264B",
        "type" => "escalation_policy_reference"
      }
    }
  end

  let(:service_client) { described_class.new }

  describe "#create" do

    subject(:service) { service_client.create(service_properties) }

    it "creates a service" do
      expect(service).to include({ "name" => "GDE Test service" })
    end

    after(:each) do
      service_client.delete(service["id"])
    end

  end

  describe "#update" do

    let(:initial_service_properties) do
      service_properties
    end

    let(:updated_service_properties) do
      initial_service_properties["description"] = "Testing update"
      initial_service_properties
    end

    let(:service_id) do
      service_client.create(initial_service_properties)["id"]
    end

    subject(:service) do
      service_client.update(service_id, updated_service_properties)
    end

    it "updates a service" do
      expect(service).to include({"description" => "Testing update"})
    end

    after(:each) do
      service_client.delete(service_id)
    end

  end

  describe "#delete" do

    let(:service_id) { service_client.create(service_properties)["id"] }

    before(:each) do
      service_client.delete(service_id)
    end

    subject(:service) { service_client.list(service_properties["name"]) }

    it "deletes a service" do
      expect(service).to be_empty
    end

  end

  describe "#get" do

    let(:service_id) { service_client.create(service_properties)["id"] }

    subject(:service) { service_client.get(service_id) }

    it "gets service by id" do
      expect(service).to include({ "name" => "GDE Test service" })
    end

    after(:each) do
      service_client.delete(service_id)
    end

  end

  describe "#list" do

    let(:service_id) { service_client.create(service_properties)["id"] }

    context "without filtering by name" do

      subject(:services) { service_client.list }

      it "lists all services" do
        expect(services).not_to be_empty
      end

      after(:each) do
        service_client.delete(service_id)
      end

    end

    context "with filtering by name" do

      subject(:services) { service_client.list(service_properties["name"]) }

      it "includes details of only one service" do
        expect(services.count).to eq 1
      end

      it "returns the correct record" do
        expect(services.first).to include({"name" => "GDE Test service"})
      end

      after(:each) do
        service_client.delete(service_id)
      end

    end
  end

  describe "#create_or_update" do

    context "when service is new" do

      before(:each) do
        allow(service_client).to receive(:list).with(service_properties["name"]).and_return([])
      end

      it "creates a service" do
        expect(service_client.create_or_update(service_properties)).to receive(:create).with(service_properties)
      end

    end

  end

end
