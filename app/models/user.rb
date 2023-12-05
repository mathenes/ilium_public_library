# frozen_string_literal: true

class User < ApplicationRecord
  has_one :member, dependent: :destroy
  has_many :reservations, dependent: :restrict_with_error

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :member, presence: true

  after_initialize :set_member

  private

  def set_member
    return if member

    build_member
  end
end
