# frozen_string_literal: true

require "rails_helper"

RSpec.describe InventorySerializer do
  let(:inventory) { create(:inventory) }

  subject(:serialized_inventory) { InventorySerializer.new(inventory).serializable_hash.as_json }

  describe "attributes" do
    it do
      expect(serialized_inventory["data"]).to have_id(inventory.id.to_s)
      expect(serialized_inventory["data"]).to have_type("inventory")
      expect(serialized_inventory["data"]).to have_attribute(:store).with_value(inventory.store.name)
      expect(serialized_inventory["data"]).to have_attribute(:model).with_value(inventory.shoe.model)
    end
  end
end
