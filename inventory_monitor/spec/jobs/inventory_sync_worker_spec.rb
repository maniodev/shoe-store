# frozen_string_literal: true

require "rails_helper"

RSpec.describe InventorySyncWorker do
  let(:redis) { MockRedis.new }
  let(:message) do
    {
      "store" => "ALDO Ste-Catherine",
      "model" => "ADERI",
      "inventory" => 10
    }
  end
  subject(:inventory_sync_worker) { described_class.new.perform }

  before do
    allow_any_instance_of(ConnectionPool).to receive(:with).and_yield(redis)
    allow(RefreshSales).to receive(:call)
    allow(RefreshRecommendations).to receive(:call)
    allow(RefreshSelectInputs).to receive(:call)

    key = "#{message['store']}:#{message['model']}"
    redis.xadd(key, { model: message["model"], inventory: message["inventory"] })
    redis.sadd("stores", message["store"])
    redis.sadd("shoes", message["model"])
    redis.hset("inventory", key, message["inventory"])
  end

  it "persists the data" do
    expect do
      inventory_sync_worker
    end.to change { Shoe.count }.by(1)
                                .and change { Store.count }.by(1)
                                                           .and change { Inventory.count }.by(1)

    shoe = Shoe.last
    store = Store.last
    inventory = Inventory.last

    expect(shoe.model).to eq "ADERI"
    expect(store.name).to eq "ALDO Ste-Catherine"
    expect(inventory.store).to eq store
    expect(inventory.shoe).to eq shoe
    expect(RefreshSales).to have_received(:call).with({ data: { "ALDO Ste-Catherine:ADERI" => "10" } })
    expect(RefreshRecommendations).to have_received(:call)
    expect(RefreshSelectInputs).to have_received(:call)
  end
end
