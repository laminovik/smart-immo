class AddColumnsToSale < ActiveRecord::Migration
  def change
    add_column :sales, :detail, :text
    add_column :sales, :temp, :string
  end
end
