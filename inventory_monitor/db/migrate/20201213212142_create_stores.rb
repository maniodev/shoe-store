class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name, comment: "Name of the store"
      t.index :name, unique: true

      t.timestamps
    end
  end
end
