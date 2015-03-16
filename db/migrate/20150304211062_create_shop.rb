class CreateShop < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :domain
      t.string :token

      t.timestamps null: false
    end
  end
end
