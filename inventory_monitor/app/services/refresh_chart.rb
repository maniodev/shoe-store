# frozen_string_literal: true

class RefreshChart
  include Interactor

  def call
    remove_scheduled_jobs

    ChartSyncWorker.new.perform(context.params)
  end

  private

  def remove_scheduled_jobs
    queue = Sidekiq::ScheduledSet.new
    queue.clear
  end
end
