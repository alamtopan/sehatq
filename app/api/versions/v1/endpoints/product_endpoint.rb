module Versions::V1::Endpoints
  class ProductEndpoint < Grape::API
    before do
      current_user
    end

    resources :products do
      desc "------------ Add Product ---------------"
      params do
        requires :category, type: String, allow_blank: false
        requires :title, type: String, allow_blank: false
        requires :price, type: Integer, allow_blank: false
        optional :cover_image, type: File
        optional :description, type: String
        requires :stock, type: Integer, allow_blank: false
      end

      post do
        @product = Product.create!(params)
        present @product, with: Versions::V1::Entities::ProductEntity, message: 'Successfully add product'
      end

      desc "------------ Update Product ---------------"
      params do
        requires :category, type: String, allow_blank: false
        requires :title, type: String, allow_blank: false
        requires :price, type: Integer, allow_blank: false
        optional :cover_image, type: File
        optional :description, type: String
        requires :stock, type: Integer, allow_blank: false
      end

      put "/:id" do
        @product = Product.find params[:id]
        @product.update!(params)
        present @product, with: Versions::V1::Entities::ProductEntity, message: 'Successfully update product'
      end

      desc "------------ Delete Product ---------------"
      delete "/:id" do
        @product = Product.find params[:id]
        present @product, with: Versions::V1::Entities::ProductEntity, message: 'Successfully delete product'
      end

      desc "------------ Show Product ---------------"
      get "/:id" do
        @product = Product.friendly.find params[:id]
        present @product, with: Versions::V1::Entities::ProductEntity, message: 'Load successfull'
      end

      desc "------------ List Product ---------------"
      params do
        optional :keywords, type: String
      end

      get do
        @products = Product.search_by(params)
        present @products, with: Versions::V1::Entities::ProductEntity
      end
    end

  end
end


