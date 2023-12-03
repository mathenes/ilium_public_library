# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    user
    book
    pick_up_time { (Time.zone.now + 1.day).change(hour: 10) }

    trait :lent do
      state { 'lent' }
    end

    trait :delivered do
      state { 'delivered' }
    end

    trait :canceled do
      state { 'canceled' }
    end
  end
end
