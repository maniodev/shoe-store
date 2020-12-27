# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshSales do
  1.upto(3) do |n|
    let!(:"shoe#{n}") { create(:shoe) }
    let!(:"store#{n}") { create(:store) }
    let!(:"inventory1#{n}") do
      create(:inventory, shoe: send("shoe#{n}"), store: send("store#{n}"), quantity: 10)
    end
  end

  subject(:refresh_dashboard) do
    described_class.call(
      data: {
        "#{store1.name}:#{shoe1.model}" => "15",
        "#{store2.name}:#{shoe2.model}" => "5",
        "#{store3.name}:#{shoe3.model}" => "10"
      }
    )
  end

  describe ".call" do
    it "broadcasts the sales data" do
      expect do
        refresh_dashboard
      end.to have_broadcasted_to("dashboard_channel").with(
        {
          "type": "sales",
          "data": [
            { shoe_model: shoe1.model, percentage: 50.0, trend: "down" },
            { shoe_model: shoe3.model, percentage: 33.33, trend: "none" },
            { shoe_model: shoe2.model, percentage: 16.67, trend: "up" }
          ]
        }
      )
    end
  end
end
