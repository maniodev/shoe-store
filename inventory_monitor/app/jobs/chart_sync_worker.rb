# frozen_string_literal: true

require "digest"

class ChartSyncWorker
  include Sidekiq::Worker

  sidekiq_options queue: :chart

  def perform(args = {})
    args = args.with_indifferent_access

    data = streams(args).each_with_object([]) do |stream, hash|
      stream_entries = REDIS_POOL.with do |client|
        client.xrevrange(stream, "+", "-", count: 30).reverse
      end
      hash << chart_line_properties(stream, stream_entries)
    end

    ActionCable.server.broadcast "dashboard_channel", { type: "chart", data: data }
    ChartSyncWorker.perform_in(5.seconds, args)
  end

  private

  def streams(args)
    store_name = args["store"].to_s
    shoe_model = args["shoe_model"].to_s

    inventories(store_name, shoe_model).map do |inventoy|
      "#{inventoy.store.name}:#{inventoy.shoe.model}"
    end
  end

  def inventories(store_name, shoe_model)
    inventories = Inventory.includes(:store, :shoe)
    inventories = inventories.joins(:store).where("stores.name ILIKE ?", "%#{store_name}%") if store_name.present?
    inventories = inventories.joins(:shoe).where("shoes.model ILIKE ?", "%#{shoe_model}%") if shoe_model.present?
    inventories
  end

  def chart_line_properties(stream_name, stream_entries)
    data = stream_entries.each_with_object([]).with_index do |(key, array), index|
      array << { x: index, y: key[1]["inventory"] }
    end
    {
      label: stream_name,
      data: data,
      lineTension: 0.3,
      borderColor: RgbColorCodeGenerator.generate(stream_name, ".7"),
      backgroundColor: RgbColorCodeGenerator.generate(stream_name, ".2"),
      labels: data,
      showLine: true,
      borderWidth: 3
    }
  end
end
