# frozen_string_literal: true

class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :user, null: false, index: { unique: true }
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
