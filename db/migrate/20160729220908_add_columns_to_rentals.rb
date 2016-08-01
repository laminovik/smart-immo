class AddColumnsToRentals < ActiveRecord::Migration
  def change
    add_column :rentals, :detail, :text
    add_column :rentals, :temp, :string
  end
end
