# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshSelectInputs do
  let!(:shoes) { create_list(:shoe, 3) }
  let!(:stores) { create_list(:store, 3) }

  subject(:refresh_select_inputs) { described_class.call }

  it "broadcasts data" do
    expect do
      refresh_select_inputs
    end.to have_broadcasted_to("dashboard_channel").with(
      {
        "type": "select_inputs",
        "data": { "shoe_models": shoes.map(&:model), "store_names": stores.map(&:name) }
      }
    )
  end
end
