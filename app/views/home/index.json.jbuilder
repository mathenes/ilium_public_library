# frozen_string_literal: true

json.name current_user&.name
json.role current_user&.member&.role
