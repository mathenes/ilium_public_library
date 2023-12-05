# frozen_string_literal: true

module Reservations
  class ManageReservation
    attr_reader :reservation, :action, :errors

    def initialize(reservation:, action:)
      @reservation = reservation
      @action = action
      @success = false
    end

    def execute
      result = perform_action
      if result
        @success = true
        return reservation
      end
      @errors = reservation.errors.full_messages
    rescue StandardError => e
      @errors = e.message
    end

    def success?
      @success
    end

    private

    def perform_action
      case action
      when 'pick_up_book'
        reservation.pick_up_book!
      when 'deliver_book'
        reservation.deliver_book!
      when 'cancel'
        reservation.cancel!
      end
    end
  end
end
