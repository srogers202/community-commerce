class CreateProductTargets < ActiveRecord::Migration
  def change
    create_table :product_targets do |t|
      t.integer :shop
      t.integer :product
      t.integer :minqty
      t.decimal :price, precision: 15, scale: 2, default: 0.0
      t.decimal :priceLessPrevious, precision: 15, scale: 2, default: 0.0
      t.integer :order
      t.boolean :refunded, default: false

      t.timestamps null: false
    end
  end
end
