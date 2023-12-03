# frozen_string_literal: true

class Reservation < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :book

  has_secure_token :reservation_token

  validates :reservation_token, presence: true
  validates :pick_up_time, presence: true
  validates :state, presence: true

  validates_comparison_of :pick_up_time, greater_than: -> { Time.zone.now }
  validate :book_availability
  validate :user_with_same_book
  validate :pick_up_at_working_hours

  aasm column: 'state' do
    state :reserved, initial: true
    state :lent
    state :delivered
    state :canceled

    event :pick_up_book do
      transitions from: :reserved, to: :lent
    end

    event :deliver_book do
      transitions from: :lent, to: :delivered
    end

    event :cancel do
      transitions from: :reserved, to: :canceled
    end
  end

  scope :by_user, ->(user) { where(user:) }

  private

  def book_availability
    return unless book

    reservations = book.reservations
    return if reservations.reserved.or(reservations.lent).count < book.total_amount

    errors.add(:book, 'has no copies available.')
  end

  def user_with_same_book
    return unless book

    reservations = book.reservations.by_user(user)
    return unless reservations.reserved.or(reservations.lent).where.not(id:).exists?

    errors.add(:book, 'was already reserved/lent by this user.')
  end

  def pick_up_at_working_hours
    return unless pick_up_time

    work_start = pick_up_time.change(hour: 9)
    work_end = pick_up_time.change(hour: 18)
    return if pick_up_time >= work_start && pick_up_time <= work_end

    errors.add(:pick_up_time, 'needs to be between 9 a.m and 6 p.m')
  end
end
