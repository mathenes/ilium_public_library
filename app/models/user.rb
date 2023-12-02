# frozen_string_literal: true

class User < ApplicationRecord
  has_one :member, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  before_validation :check_member
  after_initialize :set_member

  private

  def check_member
    return if member

    errors.add(:member, "can't be blank")
  end

  def set_member
    return if member

    build_member
  end
end
