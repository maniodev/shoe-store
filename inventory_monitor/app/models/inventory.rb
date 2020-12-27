# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :shoe
end
