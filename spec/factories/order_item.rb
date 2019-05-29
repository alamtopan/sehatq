FactoryGirl.define do
  factory :order_item do
    order_id { nil }
    product_id { nil }
    quantity { 2 }
  end
end