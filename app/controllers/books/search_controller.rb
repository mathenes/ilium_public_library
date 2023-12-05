# frozen_string_literal: true

module Books
  class SearchController < ApplicationController
    def index
      return unless params[:type] && params[:query]

      @books = query_books.order_by_title

      respond_to do |format|
        format.json { render :index }
        format.html
      end
    end

    private

    def query_books
      if params[:type].inquiry.title?
        Book.by_title(params[:query])
      else
        Book.by_author(params[:query])
      end
    end
  end
end
