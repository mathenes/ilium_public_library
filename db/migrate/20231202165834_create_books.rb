# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title, null: false, index: true
      t.string :author, null: false, index: true
      t.integer :total_amount, null: false, default: 0

      t.timestamps
    end
  end
end
