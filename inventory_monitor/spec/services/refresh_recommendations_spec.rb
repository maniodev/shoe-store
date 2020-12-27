# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshRecommendations do
  let!(:shoe1) { create(:shoe, model: "ADERI") }
  let!(:shoe2) { create(:shoe, model: "MCTYRE") }
  1.upto(2) { |n| let!(:"store#{n}") { create(:store) } }

  subject(:refresh_recommendations) { described_class.call }

  before do
    create(:inventory, shoe: shoe1, store: store1, quantity: 4)
    create(:inventory, shoe: shoe2, store: store1, quantity: 3)
    create(:inventory, shoe: shoe1, store: store2, quantity: 60)
  end

  it "broadcasts recommendations" do
    expect do
      refresh_recommendations
    end.to have_broadcasted_to("dashboard_channel").with(
      {
        "type": "notifications",
        "data": [
          "#{shoe1.model} in #{store1.name} is low in stock, consider transferring from #{store2.name}",
          "#{shoe2.model} in #{store1.name} is low in stock"
        ]
      }
    )
  end
end
