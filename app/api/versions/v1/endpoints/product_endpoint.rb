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
        present @product, with: Versions::V1::Entities::ProductEntity
      end

      desc "------------ Update Product ---------------"
      params do
        requires :category, type: String, allow_blank: false
        requires :title, type: String, allow_blank: false
        requires :price, type: Integer, allow_blank: false
        requires :cover_image, type: File, allow_blank: false
        requires :description, type: String, allow_blank: false
        requires :stock, type: Integer, allow_blank: false
      end

      put "/:id" do
        @product = Product.find params[:id]
        @product.update!(params)
        present @product, with: Versions::V1::Entities::ProductEntity
      end

      desc "------------ Delete Product ---------------"
      delete "/:id" do
        @product = Product.find params[:id]
        if @product.delete
          present @product, with: Versions::V1::Entities::ProductEntity
        else
          error!(@product.errors.full_messages, 400)
        end
      end

      desc "------------ Show Product ---------------"
      get "/:id" do
        @product = Product.friendly.find params[:id]
        error!('Product not found', 400) if @product.blank?
        present @product, with: Versions::V1::Entities::ProductEntity
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


