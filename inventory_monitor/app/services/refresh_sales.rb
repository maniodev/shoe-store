# frozen_string_literal: true

class RefreshSales
  include Interactor

  def call # rubocop:disable Metrics/AbcSize
    new_total_per_model_map, total = process_inventories(context.data)
    current_total_per_model_map = Inventory.joins(:shoe).group("shoes.model").sum(:quantity)

    data = new_total_per_model_map.each_with_object([]) do |(shoe_model, quantity), array|
      array << {
        shoe_model: shoe_model,
        percentage: ((quantity / total.to_f) * 100).round(2),
        trend: trend(quantity, current_total_per_model_map[shoe_model])
      }
    end
    sorted_data_by_percentage = data.sort_by { |datum| - datum[:percentage] }

    ActionCable.server.broadcast "dashboard_channel", { type: "sales", data: sorted_data_by_percentage }
  end

  private

  def process_inventories(inventories)
    new_total_per_model_map = Hash.new(0)
    total = 0

    inventories.each_with_object([]) do |(key, value), _array|
      _store_name, shoe_model = key.split(":")
      new_total_per_model_map[shoe_model] += value.to_i
      total += value.to_i
    end
    [new_total_per_model_map, total]
  end

  def trend(new_qty, old_qty)
    return "none" unless old_qty

    if new_qty < old_qty
      "up"
    elsif new_qty > old_qty
      "down"
    else
      "none"
    end
  end
end
