# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChartSyncWorker do
  let!(:store1) { create(:store, name: "ALDO Solomon Pond Mall") }
  let!(:store2) { create(:store, name: "ALDO Holyoke Mall") }
  let!(:shoe1) { create(:shoe, model: "CADEVEN") }
  let!(:shoe2) { create(:shoe, model: "CAELAN") }
  let!(:inventory1) { create(:inventory, shoe: shoe1, store: store1, quantity: 10) }
  let!(:inventory2) { create(:inventory, shoe: shoe2, store: store2, quantity: 20) }
  let(:redis) { MockRedis.new }
  let(:params) { {} }

  subject(:chart_sync_worker) { ChartSyncWorker.new.perform(params) }

  1.upto(2) do |n|
    let(:"stream#{n}") { "#{send("store#{n}").name}:#{send("shoe#{n}").model}" }
    let(:"data_line_#{n}") do
      {
        "label": send("stream#{n}"),
        "data": [{ x: 0, y: send("inventory#{n}").quantity.to_s }],
        "lineTension": 0.3,
        "borderColor": ::RgbColorCodeGenerator.generate(send("stream#{n}"), ".7").to_s,
        "backgroundColor": ::RgbColorCodeGenerator.generate(send("stream#{n}"), ".2").to_s,
        "labels": [{ x: 0, y: send("inventory#{n}").quantity.to_s }],
        "showLine": true,
        "borderWidth": 3
      }
    end
  end

  describe "#perform" do
    before do
      allow_any_instance_of(ConnectionPool).to receive(:with).and_yield(redis)

      redis.xadd(stream1, { model: store1.name, inventory: inventory1.quantity })
      redis.xadd(stream2, { model: store2.name, inventory: inventory2.quantity })
    end

    it "broadcasts all inventories data to dashboard_channel and schedules itself", :aggregate_failures do
      expect(ChartSyncWorker).to receive(:perform_in).with(5.seconds, params)
      expect { chart_sync_worker }.to have_broadcasted_to("dashboard_channel").with(
        { "type": "chart", "data": [data_line_1, data_line_2] }
      )
    end

    context "when parameter are passed" do
      let(:params) { { store: store1.name, shoe_model: shoe1.model } }

      it "broadcasts only the data for the matching criteria" do
        expect(ChartSyncWorker).to receive(:perform_in).with(5.seconds, params)
        expect do
          chart_sync_worker
        end.to have_broadcasted_to("dashboard_channel").with({ "type": "chart", "data": [data_line_1] })
      end
    end

    context "when no inventory is found" do
      let(:params) { { "store": "foo", "shoe_model": "bar" } }

      it "broadcasts empty data" do
        expect(ChartSyncWorker).to receive(:perform_in).with(5.seconds, params)
        expect do
          chart_sync_worker
        end.to have_broadcasted_to("dashboard_channel").with({ "type": "chart", "data": [] })
      end
    end

    context "when the stream is not found" do
      let!(:shoe3) { create(:shoe, model: "CADAUDIA") }
      let!(:store3) { create(:store, name: "ALDO Maine Mall") }
      let(:stream3) { "#{store3.name}:#{shoe3.model}" }
      let!(:inventory3) { create(:inventory, shoe: shoe3, store: store3, quantity: 10) }
      let(:params) { { "store": store3.name, "shoe_model": shoe3.model } }

      it "broadcasts line data with empty data" do
        expect(ChartSyncWorker).to receive(:perform_in).with(5.seconds, params)
        expect do
          chart_sync_worker
        end.to have_broadcasted_to("dashboard_channel").with(
          {
            "type": "chart",
            "data": [
              "label": stream3,
              "data": [],
              "lineTension": 0.3,
              "borderColor": RgbColorCodeGenerator.generate(stream3, ".7").to_s,
              "backgroundColor": RgbColorCodeGenerator.generate(stream3, ".2").to_s,
              "labels": [],
              "showLine": true,
              "borderWidth": 3
            ]
          }
        )
      end
    end
  end
end
