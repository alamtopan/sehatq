module Versions::V1::Endpoints
  class OrderEndpoint < Grape::API
    before do
      @current_user = current_user
      @current_order = current_order
      
      error!('Your not authorize', 400) if @current_order.user_id != @current_user.id
    end

    resources :orders do
      desc "------------ Add Order Items ---------------"
      params do
        requires :product_id, type: Integer, allow_blank: false
        requires :quantity, type: Integer, allow_blank: false
      end

      post do
        error!('Product already in cart', 400) if @current_order.order_items.where(product_id: params[:product_id]).present?
        @order_item = @current_order.order_items.create!(product_id: params[:product_id], quantity: params[:quantity])
        present @order_item.order, with: Versions::V1::Entities::OrderEntity
      end

      desc "------------ Update Order Item ---------------"
      params do
        requires :quantity, type: Integer, allow_blank: false
      end

      put "/order_item/:id" do
        @order_item = @current_order.order_items.find params[:id]
        @order_item.update(params)
        present @order_item.order, with: Versions::V1::Entities::OrderEntity
      end

      desc "------------ Delete Order item ---------------"
      delete "/order_items/:id" do
        @order_item = @current_order.order_items.find params[:id]
        if @order_item.destroy
          present @order_item.order, with: Versions::V1::Entities::OrderEntity
        else
          error!(@order_item.errors.full_messages, 400)
        end
      end

      desc "------------ Checkout Order ---------------"
      params do
        requires :receiver, type: String, allow_blank: false
        requires :phone, type: String, allow_blank: false
        requires :payment_method, type: String, values: ['ATM Transfer', 'Credit Card']
        requires :shipping_type, type: String, values: ['JNE', 'TIKI', 'JNT', 'POS']
        requires :shipping_address, type: String, allow_blank: false
      end

      post "/checkout" do
        error!('Order already checkout', 400) if @current_order.status != Order::PENDING
        params[:status] = Order::CHECKOUT
        @order = @current_order.update!(params)
        session.clear
        @current_order.reduction_product_stock
        @current_order
        present @current_order, with: Versions::V1::Entities::OrderEntity
      end

      desc "------------ Show Order ---------------"
      get "/:id" do
        @order = Order.find params[:id]
        error!('Order not found', 400) if @order.blank?
        present @order, with: Versions::V1::Entities::OrderEntity
      end

      desc "------------ History Order User ---------------"
      params do
        optional :keywords, type: String
      end

      get do
        @orders = @current_user.orders.search_by(params)
        present @orders, with: Versions::V1::Entities::OrderEntity
      end
    end

  end
end


