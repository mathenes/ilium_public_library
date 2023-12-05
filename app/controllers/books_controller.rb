# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :load_book

  def show
    authorize @book || Book

    respond_to do |format|
      format.json { @book ? render(:show) : render(json: { msg: 'Not found' }, status: :not_found) }
      format.html
    end
  end

  private

  def load_book
    @book = Book.find_by(id: params[:id])
  end
end
