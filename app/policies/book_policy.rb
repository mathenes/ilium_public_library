# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  attr_reader :user, :book

  # rubocop:disable Lint/MissingSuper
  def initialize(user, book)
    @user = user
    @book = book
  end
  # rubocop:enable Lint/MissingSuper

  def show?
    user.member.library_member?
  end
end
