# frozen_string_literal: true

class RemoveNameFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :name, type: :string
  end
end
