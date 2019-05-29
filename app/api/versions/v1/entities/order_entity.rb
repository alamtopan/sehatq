module Versions::V1::Entities
  class OrderEntity < Versions::V1::Entities::PaginatedEntity
		expose :id, :invoice, :price, :shipping_price, :total_price, :status, :receiver, :phone, :payment_method, :shipping_type, :shipping_address, :created_at, :updated_at
		expose :order_items, if: ->(_instance, _options) { show?(_options, 'order_items') } do |instance, options|
      instance.order_items.nil? ? {} : Versions::V1::Entities::OrderItemEntity.represent(instance.order_items, options.merge(child: true))
    end
	end
end