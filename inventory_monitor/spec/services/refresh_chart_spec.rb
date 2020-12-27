# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefreshChart do
  let(:params) { { store: "ALDO Crossgates Mall", shoe_model: "GRELIDIEN" } }
  subject(:service_call) { described_class.call(params: params) }

  describe ".call" do
    let(:scheduled_set) { instance_double(Sidekiq::ScheduledSet) }
    let(:chart_sync_worker) { instance_double(ChartSyncWorker) }

    before do
      allow(Sidekiq::ScheduledSet).to receive(:new).and_return(scheduled_set)
      allow(ChartSyncWorker).to receive(:new).and_return(chart_sync_worker)
    end

    it "cleans up the current jobs" do
      expect(scheduled_set).to receive(:clear)
      expect(chart_sync_worker).to receive(:perform).with(params)

      service_call
    end
  end
end
