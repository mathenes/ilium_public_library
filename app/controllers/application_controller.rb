# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    msg = 'You are not authorized to perform this action.'
    flash[:alert] = msg
    respond_to do |format|
      format.json { render json: { msg: }, status: :bad_request }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end
