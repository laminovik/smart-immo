class AddColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :rentals_count, :integer
    add_column :cities, :sales_count, :integer
  end
end
