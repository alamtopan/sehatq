class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.float :price, default: 0
      t.integer :quantity, default: 0
      t.float :total_price, default: 0

      t.timestamps
    end

    add_index :order_items, :product_id
    add_index :order_items, :order_id
  end
end
