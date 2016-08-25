class AddColumnsToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :rentals_count, :integer
    add_column :districts, :sales_count, :integer
  end
end
