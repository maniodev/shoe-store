# frozen_string_literal: true

module Types
  class InventoryType < Types::BaseObject
    field :id, ID, null: false
    field :shoe_id, Integer, null: false
    field :store_id, Integer, null: false
    field :quantity, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :shoe, Types::ShoeType, null: false
    field :store, Types::StoreType, null: false

    delegate :shoe, to: :object

    delegate :store, to: :object
  end
end
