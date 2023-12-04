# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :reservations, dependent: :restrict_with_error

  validates :title, presence: true
  validates :author, presence: true
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :by_title, ->(title) { where('lower(title) like ?', "%#{title.downcase}%") }
  scope :by_author, ->(author) { where('lower(author) like ?', "%#{author.downcase}%") }
  scope :order_by_title, -> { order(title: :asc) }

  def available_for?(user:)
    reservations.build({ user:, pick_up_time: Time.current.tomorrow.change(hour: 10) }).valid?
  end
end
