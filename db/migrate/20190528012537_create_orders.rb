class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :invoice
      t.float :price, default: 0
      t.float :shipping_price, default: 0
      t.float :total_price, default: 0
      t.string :status, default: 'pending'
      t.integer :user_id

      t.timestamps
    end

    add_index :orders, :user_id
  end
end
