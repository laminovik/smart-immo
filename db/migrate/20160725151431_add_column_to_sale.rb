class AddColumnToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sqm_price, :integer
  end
end
