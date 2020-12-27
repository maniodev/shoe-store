# frozen_string_literal: true

require "rails_helper"

RSpec.describe InventoriesChannel do
  describe "#subscribed" do
    it "subscribes to the stream" do
      subscribe

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("dashboard_channel")
    end
  end

  describe "#unsubscribed" do
    before { subscribe }

    it "unsubscribes from the stream" do
      unsubscribe

      expect(subscription).not_to have_stream_from("dashboard_channel")
    end
  end
end
