# frozen_string_literal: true

FactoryBot.define do
  factory :shoe do
    sequence(:model) { |n| "BUTAUD#{n}" }
  end
end
