# frozen_string_literal: true

class Member < ApplicationRecord
  ROLES = { library_member: 0, library_clerk: 1 }.freeze

  belongs_to :user

  enum :role, ROLES

  validates :user_id, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES.stringify_keys.keys }
end
