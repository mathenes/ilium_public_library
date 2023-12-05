# frozen_string_literal: true

class ReservationPolicy < ApplicationPolicy
  attr_reader :user, :book

  # rubocop:disable Lint/MissingSuper
  def initialize(user, reservation)
    @user = user
    @reservation = reservation
  end
  # rubocop:enable Lint/MissingSuper

  def index?
    user.member.library_clerk?
  end

  def show?
    index?
  end

  def update?
    index?
  end

  def create?
    user.member.library_member?
  end
end
