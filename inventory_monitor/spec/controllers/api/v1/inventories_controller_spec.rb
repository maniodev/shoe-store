# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::InventoriesController, type: :controller do
  let!(:inventory1) { create(:inventory) }
  let!(:inventory2) { create(:inventory) }

  describe "#index" do
    it "returns all inventories in json" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({
        data: [
          {
            "id" => inventory1.id.to_s,
            "type" => "inventory",
            "attributes" => {
              "quantity" => inventory1.quantity,
              "store" => inventory1.store.name,
              "model" => inventory1.shoe.model
            }
          },
          {
            "id" => inventory2.id.to_s,
            "type" => "inventory",
            "attributes" => {
              "quantity" => inventory2.quantity,
              "store" => inventory2.store.name,
              "model" => inventory2.shoe.model
            }
          }
        ]
      }.to_json)
    end
  end
end
