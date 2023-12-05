# frozen_string_literal: true

json.extract! @reservation, :id, :reservation_token, :pick_up_time, :state
json.pick_up_time @reservation.pick_up_time.strftime('%B %d, %Y %H:%M %p')
json.user do
  json.email @reservation.user.email
end
json.book do
  json.title @reservation.book.title
  json.author @reservation.book.author
end
