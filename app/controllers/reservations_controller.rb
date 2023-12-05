# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :load_reservation

  def index
    authorize @reservation || Reservation

    respond_to do |format|
      format.json { @reservation ? render(:show) : render(json: { msg: 'Not found' }, status: :not_found) }
      format.html
    end
  end

  def show
    authorize @reservation || Reservation

    respond_to do |format|
      format.json { @reservation ? render(:show) : render(json: { msg: 'Not found' }, status: :not_found) }
      format.html
    end
  end

  def update
    render json: { msg: 'Not found' }, status: :not_found unless @reservation

    authorize @reservation

    manage_reservation = Reservations::ManageReservation.new(reservation: @reservation,
                                                             action: params[:reservation][:action])
    manage_reservation.execute
    if manage_reservation.success?
      respond_to { |format| format.json { render :show } }
    else
      render json: { msg: manage_reservation.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_reservation
    @reservation = Reservation.find_by(reservation_token: params[:reservation_token]) if params[:reservation_token]
  end
end
