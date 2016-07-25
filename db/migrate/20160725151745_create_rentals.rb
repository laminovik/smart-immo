class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.references :city, index: true, foreign_key: true
      t.references :district, index: true, foreign_key: true
      t.references :type, index: true, foreign_key: true
      t.integer :price
      t.integer :surface
      t.integer :sqm_price
      t.integer :rooms
      t.integer :bathrooms
      t.string :website
      t.string :link
      t.string :last_update

      t.timestamps null: false
    end
  end
end
