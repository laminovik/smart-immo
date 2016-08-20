class CreateScraps < ActiveRecord::Migration
  def change
    create_table :scraps do |t|
      t.string :website
      t.string :category
      t.references :city, index: true, foreign_key: true
      t.time :started
      t.time :ended
      t.integer :total_scraped
      t.float :variation

      t.timestamps null: false
    end
  end
end
