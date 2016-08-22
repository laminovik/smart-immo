class AddThreeColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :yield, :float
    add_column :cities, :buy_sqm, :integer
    add_column :cities, :rent_sqm, :integer
  end
end
