class AddOtherAttributesForOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :shipping_address, :string
    add_column :orders, :shipping_type, :string
    add_column :orders, :phone, :string
    add_column :orders, :receiver, :string
    add_column :orders, :payment_method, :string
  end
end
