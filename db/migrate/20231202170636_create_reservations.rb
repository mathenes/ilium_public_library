# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.string :reservation_token, null: false, index: { unique: true }
      t.datetime :pick_up_time, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
