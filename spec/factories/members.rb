# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    user

    trait :library_clerk do
      role { Member::ROLES[:library_clerk] }
    end
  end
end
