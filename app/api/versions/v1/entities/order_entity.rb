module Versions::V1::Entities
  class OrderEntity < Grape::Entity
		expose :id, :invoice, :price, :shipping_price, :total_price, :status, :receiver, :phone, :payment_method, :shipping_type, :shipping_address, :created_at, :updated_at
		expose :order_items, using: Versions::V1::Entities::OrderItemEntity
	end
end