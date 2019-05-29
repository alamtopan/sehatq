module Versions::V1::Entities
  class ProductEntity < Versions::V1::Entities::PaginatedEntity
		expose :id, :slug, :title, :price, :description, :stock, :cover_image, :created_at, :updated_at
	end
end