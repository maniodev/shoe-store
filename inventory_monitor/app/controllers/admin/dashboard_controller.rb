# frozen_string_literal: true

require "sidekiq/api"

module Admin
  class DashboardController < ApplicationController
    def index
      @shoe_models = Shoe.all.map(&:model)
      @store_names = Store.all.map(&:name)
    end
    end
  end
end
