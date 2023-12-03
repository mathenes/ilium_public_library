# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    author { 'Author Name' }
    total_amount { 5 }
  end
end
