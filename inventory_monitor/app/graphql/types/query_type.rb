# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :stores, [Types::StoreType], null: false, description: "List stores"
    field :store, Types::StoreType, null: false do
      argument :id, ID, required: true
    end
    field :shoe, Types::ShoeType, null: false do
      argument :id, ID, required: true
    end
    field :shoes, [Types::ShoeType], null: false, description: "List shoes"
    field :inventories, [Types::InventoryType], null: false, description: "List inventories"

    def stores
      Store.all
    end

    def store(id:)
      Store.find(id)
    end

    def shoes
      Shoe.all
    end

    def shoe(id:)
      Shoe.find(id)
    end

    def inventories
      Inventory.all
    end
  end
end
