# frozen_string_literal: true

class Shoe < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :stores, through: :inventories
end
