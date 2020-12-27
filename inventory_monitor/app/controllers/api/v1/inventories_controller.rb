# frozen_string_literal: true

module Api
  module V1
    class InventoriesController < ApplicationController
      def index
        @inventories = Inventory.all

        render json: InventorySerializer.new(Inventory.all).serializable_hash
      end
    end
  end
end
