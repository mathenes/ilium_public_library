# frozen_string_literal: true

module Books
  class ReservationsController < ApplicationController
    before_action :load_book

    def create
      @reservation = @book.reservations.build(reservation_params)
      authorize @reservation

      @reservation.user = current_user
      if @reservation.save
        render json: @reservation
      else
        render json: { msg: @reservation.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def load_book
      @book = Book.find(params[:book_id])
    end

    def reservation_params
      params.require(:reservation).permit(:pick_up_time)
    end
  end
end
