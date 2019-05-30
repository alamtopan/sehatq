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
        @order_item = OrderService::Cart.new(params: params, current_order: @current_order).add_cart
        present @order_item.order, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
      end

      desc "------------ Update Order Item ---------------"
      params do
        requires :quantity, type: Integer, allow_blank: false
      end

      put "/order_items/:id" do
        @order_item = OrderService::Cart.new(params: params, current_order: @current_order).update_quantity
        present @order_item.order, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
      end

      desc "------------ Delete Order item ---------------"
      delete "/order_items/:id" do
        @order_item = OrderService::Cart.new(params: params, current_order: @current_order).remove_cart
        present @order_item.order, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
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
        @order = OrderService::Cart.new(params: params, current_order: @current_order).checkout
        session.clear if @order.persisted?
        present @order, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
      end

      desc "------------ Show Order ---------------"
      get "/:id" do
        @order = Order.find params[:id]
        present @order, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
      end

      desc "------------ History Order User ---------------"
      params do
        optional :keywords, type: String
      end

      get do
        @orders = @current_user.orders.search_by(params)
        present @orders, with: Versions::V1::Entities::OrderEntity, include: 'order_items,product'
      end
    end

  end
end


