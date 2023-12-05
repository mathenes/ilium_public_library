# frozen_string_literal: true

json.extract! book, :id, :title, :author
json.available book.available_for?(user: current_user)
