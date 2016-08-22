class AddTwoColumnsToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :sqm_buy, :integer
    add_column :districts, :sqm_rent, :integer
  end
end
