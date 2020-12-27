class CreateShoes < ActiveRecord::Migration[6.1]
  def change
    create_table :shoes do |t|
      t.string :model, comment: "Model name of the shoe"
      t.index :model, unique: true

      t.timestamps
    end
  end
end
