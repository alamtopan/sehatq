class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_save :calculate_price
  after_save :update_order
  after_destroy :update_order
  
  private 
    # ----- To calculate total order before save -----
    def calculate_price
      self.price = product.price
      self.total_price = price * quantity      
    end

    # ----- To update model order after create, update or delete -----
    def update_order
      if order.present?
        order.price = order.order_items.pluck(:total_price).sum rescue 0
        order.shipping_price = 0
        order.total_price = order.price + order.shipping_price
        order.save
      end
    end
end
