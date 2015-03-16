class CreateProductExpirations < ActiveRecord::Migration
  def change
    create_table :product_expirations do |t|
      t.integer :shop
      t.integer :product
      t.datetime :expiration
      t.boolean :complete

      t.timestamps null: false
    end
  end
end
