# frozen_string_literal: true

class InventoriesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
