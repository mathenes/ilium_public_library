# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :load_book

  def show
    respond_to do |format|
      format.json do
        if @book
          render :show
        else
          render json: { msg: 'Not found' }, status: :not_found
        end
      end
      format.html
    end
  end

  private

  def load_book
    @book = Book.find_by(id: params[:id])
  end
end
