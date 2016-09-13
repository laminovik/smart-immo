class AddColumnToCities < ActiveRecord::Migration
  def change
    add_column :cities, :maroc_annonces_code, :integer
  end
end
