module OrderService
  class Cart
    def initialize(opsts={})
      @params = opsts[:params]
      @current_order = opsts[:current_order]
    end

    def check_item?
      @current_order.order_items.where(product_id: @params[:product_id]).present?
    end

    def add_cart
      raise ::StandardError, 'Product already in cart' if check_item?
      @current_order.order_items.create!(product_id: @params[:product_id], quantity: @params[:quantity])
    end

    def update_quantity
      @order_item = @current_order.order_items.find @params[:id]
      @order_item.update(@params)
      @order_item
    end

    def remove_cart
      @order_item = @current_order.order_items.find @params[:id]
      @order_item.destroy
    end

    def checkout
      raise ::StandardError, 'Order already checkout' if @current_order.status != Order::PENDING
      raise ::StandardError, 'Order items is empty, please add cart product first' if @current_order.order_items.blank?
      @params[:status] = Order::CHECKOUT
      @order = @current_order.update!(@params)
      @current_order.reduction_product_stock
      @current_order
    end
  end
end