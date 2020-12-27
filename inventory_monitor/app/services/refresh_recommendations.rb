# frozen_string_literal: true

class RefreshRecommendations
  include Interactor

  THRESHOLD = 5 # lowest before triggering alert
  MINIMUM_STOCK_SHAREABLE = 40 # minimum to consider transferring to others

  def call
    messages = inventories_low_in_stock.each_with_object([]) do |inventory, array|
      message = "#{inventory.shoe.model} in #{inventory.store.name} is low in stock"
      stores_to_take_from = store_names_with_higher_stock(inventory)

      message += ", consider transferring from #{stores_to_take_from}" if stores_to_take_from.present?
      array << message
    end

    ActionCable.server.broadcast "dashboard_channel", { type: "notifications", data: messages }
  end

  private

  def inventories_low_in_stock
    Inventory.where("quantity < ?", THRESHOLD)
  end

  def store_names_with_higher_stock(inventory_with_low_stock)
    Inventory.joins(:store)
             .where("shoe_id = ? AND store_id != ? AND quantity > ?",
                    inventory_with_low_stock.shoe_id,
                    inventory_with_low_stock.store_id,
                    MINIMUM_STOCK_SHAREABLE).map { |inventory| inventory.store.name }.join(", ")
  end
end
