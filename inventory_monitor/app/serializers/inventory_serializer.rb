# frozen_string_literal: true

class InventorySerializer
  include JSONAPI::Serializer

  attributes :quantity
  attribute :store do |object|
    object.store.name
  end
  attribute :model do |object|
    object.shoe.model
  end
end
