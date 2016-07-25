class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :city, index: true, foreign_key: true
      t.references :district, index: true, foreign_key: true
      t.references :type, index: true, foreign_key: true
      t.integer :price
      t.integer :surface
      t.integer :rooms
      t.integer :bathrooms
      t.string :website
      t.string :link
      t.string :last_update

      t.timestamps null: false
    end
  end
end
