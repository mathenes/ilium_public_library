# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
