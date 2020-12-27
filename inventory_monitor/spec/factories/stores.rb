# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "ALDO Pheasant Lane Mall#{n}" }
  end
end
