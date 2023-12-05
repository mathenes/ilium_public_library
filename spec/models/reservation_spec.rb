# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Reservation, type: :model do
  subject(:reservation) { create(:reservation) }

  let(:user) { create(:user) }
  let(:book) { create(:book, total_amount: 5) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:reservation_token) }
    it { is_expected.to validate_presence_of(:pick_up_time) }
    it { is_expected.to validate_presence_of(:state) }

    describe 'validates only future pick_up_time' do
      it 'allows pick_up_time to be greater than current time' do
        reservation = build(:reservation, user:, book:, pick_up_time: (Time.zone.now + 1.day).change(hour: 9))
        expect(reservation).to be_valid
      end

      it 'does not allow pick_up_time to be less than current time' do
        reservation = build(:reservation, user:, book:, pick_up_time: (Time.zone.now - 1.day).change(hour: 9))
        reservation.valid?
        expect(reservation.errors[:pick_up_time]).to include("must be greater than #{Time.zone.now}")
      end
    end

    describe 'validates pick_up_time is during working hours' do
      it 'allows a pick up time between 9 a.m and 6 p.m' do
        reservation_before_opening = build(:reservation, user:, book:,
                                                         pick_up_time: (Time.zone.now + 1.day).change(hour: 10))
        expect(reservation_before_opening).to be_valid
      end

      it 'does not allow a pick up time before 9 a.m' do
        reservation_before_opening = build(:reservation, user:, book:,
                                                         pick_up_time: (Time.zone.now + 1.day).change(hour: 8, min: 59))
        reservation_before_opening.valid?
        expect(reservation_before_opening.errors[:pick_up_time]).to include('needs to be between 9 a.m and 6 p.m')
      end

      it 'does not allow a pick up time after 6 p.m' do
        reservation_after_closing = build(:reservation, user:, book:,
                                                        pick_up_time: (Time.zone.now + 1.day).change(hour: 18, min: 1))
        reservation_after_closing.valid?
        expect(reservation_after_closing.errors[:pick_up_time]).to include('needs to be between 9 a.m and 6 p.m')
      end
    end

    describe 'validates book availability' do
      context 'with reservations in "reserved" state' do
        before { create_list(:reservation, book.total_amount, book:) }

        it 'does not allow a book to be reserved if all copies are reserved' do
          reservation = build(:reservation, book:)
          reservation.valid?
          expect(reservation.errors[:book]).to include('has no copies available.')
        end

        it 'allows a book to be reserved if some reserved copy gets canceled' do
          described_class.last.cancel!
          reservation = build(:reservation, book:)
          expect(reservation.valid?).to be true
        end
      end

      context 'with reservations in "lent" state' do
        before { create_list(:reservation, book.total_amount, :lent, book:) }

        it 'does not allow a book to be reserved if all copies are lent' do
          reservation = build(:reservation, book:)
          reservation.valid?
          expect(reservation.errors[:book]).to include('has no copies available.')
        end

        it 'allows a book to be reserved if some lent copy gets delivered' do
          described_class.last.deliver_book!
          reservation = build(:reservation, book:)
          expect(reservation.valid?).to be true
        end
      end
    end

    describe 'validates user with same book' do
      it 'does not allow the same user to reserve a book that is currenly reserved by him' do
        create(:reservation, user:, book:)
        reservation = build(:reservation, user:, book:)
        reservation.valid?
        expect(reservation.errors[:book]).to include('was already reserved/lent by this user.')
      end

      it 'does not allow the same user to reserve a book that is currenly lent to him' do
        reservation = create(:reservation, user:, book:)
        reservation.pick_up_book!
        new_reservation = build(:reservation, user:, book:)
        new_reservation.valid?
        expect(new_reservation.errors[:book]).to include('was already reserved/lent by this user.')
      end

      it 'allows the same user to reserve a book that was delivered by him' do
        old_reservation = create(:reservation, :lent, user:, book:)
        old_reservation.deliver_book!
        new_reservation = build(:reservation, user:, book:)
        expect(new_reservation).to be_valid
      end

      it 'allows the same user to reserve a book that was canceled by him' do
        old_reservation = create(:reservation, user:, book:)
        old_reservation.cancel!
        new_reservation = build(:reservation, user:, book:)
        expect(new_reservation).to be_valid
      end
    end
  end

  describe 'state machine' do
    it 'initial state should be reserved' do
      reservation = build(:reservation)
      expect(reservation).to be_reserved
    end

    it 'transitions to lent when pick_up_book event is called' do
      reservation = create(:reservation, user:, book:)
      reservation.pick_up_book
      expect(reservation).to be_lent
    end

    it 'transitions to delivered when deliver_book event is called' do
      reservation = create(:reservation, :lent, user:, book:)
      reservation.deliver_book
      expect(reservation).to be_delivered
    end

    it 'transitions to canceled when cancel event is called' do
      reservation = create(:reservation, user:, book:)
      reservation.cancel
      expect(reservation).to be_canceled
    end
  end
end
# rubocop:enable Metrics/BlockLength
