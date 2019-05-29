module Versions::V1::Entities
  class OrderItemEntity < Grape::Entity
		expose :id, :price, :quantity, :total_price, :created_at, :updated_at
		expose :product, using: Versions::V1::Entities::ProductEntity
	end
end