# frozen_string_literal: true

json.email current_user&.email
json.role current_user&.member&.role
