class Order < ApplicationRecord
  # extend FriendlyId
  # friendly_id :invoice, use: :slugged

  belongs_to :user
  has_many :order_items, dependent: :destroy

  PENDING = 'pending'
  CHECKOUT = 'checkout'
  PAID = 'paid'
  CANCEL = 'cancel'

  STATUSES = [Order::PENDING, Order::CHECKOUT, Order::PAID, Order::CANCEL]

  before_create :generate_invoice_code

  include OrderModule::Filter

  # ----- To reduction product stock after checkout -----
  def reduction_product_stock
    if order_items.present?
      order_items.each do |item|
        product = item.product
        product.stock = product.stock - item.quantity
        product.save
      end
    end
  end

  private
    # ----- To generate invoice before save -----
    def generate_invoice_code
      self.invoice = Time.now.to_i + SecureRandom.random_number(1000)
    end
end
