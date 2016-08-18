class AddColumnToDistrict < ActiveRecord::Migration
  def change
    add_column :districts, :avito_code, :string
  end
end
