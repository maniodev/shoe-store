# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    association :store
    association :shoe
  end
end
