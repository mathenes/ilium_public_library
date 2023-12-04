# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    respond_to do |format|
      format.json { render :index }
      format.html
    end
  end
end
