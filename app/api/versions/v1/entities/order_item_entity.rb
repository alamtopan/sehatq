module Versions::V1::Entities
  class OrderItemEntity < Versions::V1::Entities::PaginatedEntity
		expose :id, :price, :quantity, :total_price, :created_at, :updated_at
		expose :product, if: ->(_instance, _options) { show?(_options, 'product') } do |instance, options|
      instance.product.nil? ? {} : Versions::V1::Entities::ProductEntity.represent(instance.product, options.merge(child: true))
    end
	end
end