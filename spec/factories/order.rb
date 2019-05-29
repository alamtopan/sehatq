FactoryGirl.define do
  factory :order do
    user_id { nil }
    shipping_address { 0 }
    shipping_type { 'JNE' }
    phone {'08577795923'}
    receiver {Faker::Name.name}
    payment_method {'ATM Transfer'}
  end
end