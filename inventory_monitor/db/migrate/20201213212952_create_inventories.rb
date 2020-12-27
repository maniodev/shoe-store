class CreateInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :inventories do |t|
      t.references :shoe, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.integer :quantity, default: 1, comment: "Quantity in stock"

      t.index [:shoe_id, :store_id], unique: true
      t.timestamps
    end
  end
end
