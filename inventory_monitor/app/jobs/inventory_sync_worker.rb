# frozen_string_literal: true

class InventorySyncWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform
    REDIS_POOL.with do |client|
      sync_stores(client.smembers("stores"))
      sync_shoes(client.smembers("shoes"))

      inventories = client.hgetall("inventory")
      refresh_dashboard(inventories)

      sync_inventories(inventories)
    end
  end

  private

  def sync_stores(store_names)
    data = store_names.each_with_object([]) do |name, array|
      array << { name: name }
    end

    Store.import(data, on_duplicate_key_ignore: true)
  end

  def sync_shoes(model_names)
    data = model_names.each_with_object([]) do |name, array|
      array << { model: name }
    end

    Shoe.import(data, on_duplicate_key_ignore: true)
  end

  def refresh_dashboard(inventories)
    RefreshSales.call(data: inventories)
    RefreshRecommendations.call
    RefreshSelectInputs.call
  end

  def sync_inventories(inventories)
    data = inventories.each_with_object([]) do |(key, value), array|
      store_name, shoe_model = key.split(":")
      array << Inventory.new(
        store: Store.find_by!(name: store_name),
        shoe: Shoe.find_by!(model: shoe_model),
        quantity: value
      )
    end

    Inventory.import data, on_duplicate_key_update: { conflict_target: %i[shoe_id store_id], columns: [:quantity] }
  end
end
