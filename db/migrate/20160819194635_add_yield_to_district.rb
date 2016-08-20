class AddYieldToDistrict < ActiveRecord::Migration
  def change
    add_column :districts, :yield, :float
  end
end
