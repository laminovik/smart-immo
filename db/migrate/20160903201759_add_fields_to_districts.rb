class AddFieldsToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :maroc_annonces_name, :string
    add_column :districts, :maroc_annonces_code, :integer
  end
end
