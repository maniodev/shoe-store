# frozen_string_literal: true

require "sidekiq/api"

module Admin
  class DashboardController < ApplicationController
    def index
      @shoe_models = Shoe.all.map(&:model)
      @store_names = Store.all.map(&:name)

      RefreshChart.call(params: chart_params)
    end

    def refresh
      RefreshChart.call(params: chart_params)
    end

    private

    def chart_params
      params.permit(:store, :shoe_model).to_h
    end
  end
end
