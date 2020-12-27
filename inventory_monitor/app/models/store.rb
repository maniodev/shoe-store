# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :shoes, through: :inventories
end
